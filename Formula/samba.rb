class Samba < Formula
  # Samba can be used to share directories with the guest in QEMU user-mode
  # (SLIRP) networking with the `-net nic -net user,smb=/share/this/with/guest`
  # option. The shared folder appears in the guest as "\\10.0.2.4\qemu".
  desc "SMB/CIFS file, print, and login server for UNIX"
  homepage "https://www.samba.org/"
  url "https://download.samba.org/pub/samba/stable/samba-4.14.7.tar.gz"
  sha256 "6f50353f9602aa20245eb18ceb00e7e5ec793df0974aebd5254c38f16d8f1906"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://www.samba.org/samba/download/"
    regex(/href=.*?samba[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "20bb775d1b544da1c775e080903a1f7a8ab8b30f1b5a254b6537f65f85ba449f"
    sha256 big_sur:       "31c763e3ff4197649a5aed042ceb1d43de52fa3d3a6fecb56cd02dd1ca10e188"
    sha256 catalina:      "ca0557e42a691a5098c106ac5e336af492338d80b99b1505bc6b7a5d379caed7"
    sha256 mojave:        "1b8b305321311c1ebc2783a5d2eff42ceb7ea9f250c156fd9e82751a413ea4e2"
    sha256 x86_64_linux:  "e6a226ea7bf98915a0c1fcc90a65556af66b1b68dc2a50f45b5bfa8d0d0f27bf"
  end

  # configure requires python3 binary to be present, even when --disable-python is set.
  depends_on "python@3.9" => :build
  depends_on "gnutls"

  uses_from_macos "flex" => :build
  uses_from_macos "perl" => :build

  resource "Parse::Yapp" do
    url "https://cpan.metacpan.org/authors/id/W/WB/WBRASWELL/Parse-Yapp-1.21.tar.gz"
    sha256 "3810e998308fba2e0f4f26043035032b027ce51ce5c8a52a8b8e340ca65f13e5"
  end

  # Workaround for "charset_macosxfs.c:278:4: error: implicit declaration of function 'DEBUG' is invalid in C99"
  # Can be removed when https://bugzilla.samba.org/show_bug.cgi?id=14680 gets resolved.
  patch do
    url "https://attachments.samba.org/attachment.cgi?id=16579"
    sha256 "86fce5306349d1c8f3732ca978a31065df643c8770114dc9d068b7b4dfa7d282"
  end

  def install
    # avoid `perl module "Parse::Yapp::Driver" not found` error on macOS 10.xx (not required on 11)
    if MacOS.version < :big_sur
      ENV.prepend_create_path "PERL5LIB", buildpath/"lib/perl5"
      ENV.prepend_path "PATH", buildpath/"bin"
      resource("Parse::Yapp").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{buildpath}"
        system "make"
        system "make", "install"
      end
    end
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}/private" if OS.linux?
    system "./configure",
           "--disable-cephfs",
           "--disable-cups",
           "--disable-iprint",
           "--disable-glusterfs",
           "--disable-python",
           "--without-acl-support",
           "--without-ad-dc",
           "--without-ads",
           "--without-dnsupdate",
           "--without-ldap",
           "--without-libarchive",
           "--without-json",
           "--without-ntvfs-fileserver",
           "--without-pam",
           "--without-regedit",
           "--without-syslog",
           "--without-utmp",
           "--without-winbind",
           "--with-shared-modules=!vfs_snapper",
           "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    on_macos do
      # macOS has its own SMB daemon as /usr/sbin/smbd, so rename our smbd to samba-dot-org-smbd to avoid conflict.
      # samba-dot-org-smbd is used by qemu.rb .
      # Rename mdfind and profiles as well to avoid conflicting with /usr/bin/{mdfind,profiles}
      { sbin => "smbd", bin => "mdfind", bin => "profiles" }.each do |dir, cmd|
        mv dir/cmd, dir/"samba-dot-org-#{cmd}"
      end
    end
  end

  def caveats
    on_macos do
      <<~EOS
        To avoid conflicting with macOS system binaries, some files were installed with non-standard name:
        - smbd:     #{HOMEBREW_PREFIX}/sbin/samba-dot-org-smbd
        - mdfind:   #{HOMEBREW_PREFIX}/bin/samba-dot-org-mdfind
        - profiles: #{HOMEBREW_PREFIX}/bin/samba-dot-org-profiles

        On macOS, Samba should be executed as a non-root user: https://bugzilla.samba.org/show_bug.cgi?id=8773
      EOS
    end
  end

  test do
    smbd = "#{sbin}/smbd"
    on_macos do
      smbd = "#{sbin}/samba-dot-org-smbd"
    end

    system smbd, "--build-options"
    system smbd, "--version"

    mkdir_p "samba/state"
    mkdir_p "samba/data"
    (testpath/"samba/data/hello").write "hello"

    # mimic smb.conf generated by qemu
    # https://github.com/qemu/qemu/blob/v6.0.0/net/slirp.c#L862
    (testpath/"smb.conf").write <<~EOS
      [global]
      private dir=#{testpath}/samba/state
      interfaces=127.0.0.1
      bind interfaces only=yes
      pid directory=#{testpath}/samba/state
      lock directory=#{testpath}/samba/state
      state directory=#{testpath}/samba/state
      cache directory=#{testpath}/samba/state
      ncalrpc dir=#{testpath}/samba/state/ncalrpc
      log file=#{testpath}/samba/state/log.smbd
      smb passwd file=#{testpath}/samba/state/smbpasswd
      security = user
      map to guest = Bad User
      load printers = no
      printing = bsd
      disable spoolss = yes
      usershare max shares = 0
      [test]
      path=#{testpath}/samba/data
      read only=no
      guest ok=yes
      force user=#{ENV["USER"]}
    EOS

    port = free_port
    spawn smbd, "-S", "-F", "--configfile=smb.conf", "--port=#{port}", "--debuglevel=4", in: "/dev/null"

    sleep 5
    mkdir_p "got"
    system "smbclient", "-p", port.to_s, "-N", "//127.0.0.1/test", "-c", "get hello #{testpath}/got/hello"
    assert_equal "hello", (testpath/"got/hello").read
  end
end
