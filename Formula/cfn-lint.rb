class CfnLint < Formula
  include Language::Python::Virtualenv

  desc "Validate CloudFormation templates against the CloudFormation spec"
  homepage "https://github.com/aws-cloudformation/cfn-python-lint/"
  url "https://files.pythonhosted.org/packages/e5/62/d2c27f3a425267b69e8c9f9efcef8e0466a1d9eab0ae03ce0881f618cce5/cfn-lint-0.53.1.tar.gz"
  sha256 "45fe0ab893e0ef6dce6f6e41840f6314a5d22ce4c8fa1b46e5970f05889d1621"
  license "MIT-0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4c0be073fd576c4e242437984bd47b1ba309b32e0dbdff54d7e739bf805658cd"
    sha256 cellar: :any_skip_relocation, big_sur:       "44f3d68ba857e4239401e83d2e5e42a201cc624be49d904f6f0c8bf24adbb8cf"
    sha256 cellar: :any_skip_relocation, catalina:      "299299c23f1218c84ee3ff224a2fb2bd6527ed10dd0314dba8a85393b04378fc"
    sha256 cellar: :any_skip_relocation, mojave:        "23a181f0c9c8d4151b085ac0ae4823f160e91d17169ac9ae088e6407605ed51d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a4e447dfc94e1ab96050cf43d8ef60dbd02629989637908d797ba86a43c472c"
  end

  depends_on "python@3.9"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/ed/d6/3ebca4ca65157c12bd08a63e20ac0bdc21ac7f3694040711f9fd073c0ffb/attrs-21.2.0.tar.gz"
    sha256 "ef6aaac3ca6cd92904cdd0d83f629a15f18053ec84e6432106f7a4d04ae4f5fb"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/77/42/30a9106f3e712f530cc93f8510364cde417b42acb6b64096a7b34eb0c1b8/aws-sam-translator-1.38.0.tar.gz"
    sha256 "0ecadda9cf5ab2318f57f1253181a2151e4c53cd35d21717a923c075a5a65cb6"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/1e/e8/eeb83a81a50faa21ca3a1865ce60649f857749adf727caf72851de1f9948/boto3-1.18.32.tar.gz"
    sha256 "f4b17a2b6e04e5ec6f494e643d05b06dd60c88943f33d6f9650dd9e7f89a7022"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/5f/89/705ac13ba33df49093d878d94fad7e8f96cf43782edcfb93dbbbd9bacffe/botocore-1.21.32.tar.gz"
    sha256 "95ff61534b2a423d0e70067c39615e4e70c119773d2180d7254bf4025c54396d"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/21/67/83452af2a6db7c4596d1e2ecaa841b9a900980103013b867f2865e5e1cf0/jsonpatch-1.32.tar.gz"
    sha256 "b6ddfe6c3db30d81a96aaeceb6baf916094ffa23d7dd5fa2c13e13f8b6e600c2"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/6b/35/400557d3df63269a4c010cbd4865910b3c1718fbfe8d83210b216cd3efcf/jsonpointer-2.1.tar.gz"
    sha256 "5a34b698db1eb79ceac454159d3f7c12a451a91f6334a4f638454327b7a89962"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/69/11/a69e2a3c01b324a77d3a7c0570faa372e8448b666300c4117a516f8b1212/jsonschema-3.2.0.tar.gz"
    sha256 "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a"
  end

  # only doing this because junit-xml source is not available in PyPI for v1.9
  resource "junit-xml" do
    url "https://github.com/kyrus/python-junit-xml.git",
        revision: "4bd08a272f059998cedf9b7779f944d49eba13a6"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/4b/3b/4378599026b81d1987a6e0d6d3d677e8f26308a039491a6b8a1914e58a4c/networkx-2.6.2.tar.gz"
    sha256 "2306f1950ce772c5a59a57f5486d59bb9cab98497c45fc49cbc45ac0dec119bb"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/f4/d7/0fa558c4fb00f15aabc6d42d365fcca7a15fcc1091cd0f5784a14f390b7f/pyrsistent-0.18.0.tar.gz"
    sha256 "773c781216f8c2900b42a7b638d5b517bb134ae1acbebe4d1e8f1f41ea60eb4b"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/88/ef/4d1b3f52ae20a7e72151fde5c9f254cd83f8a49047351f34006e517e1655/s3transfer-0.5.0.tar.gz"
    sha256 "50ed823e1dc5868ad40c8dc92072f757aa0e653a192845c94a3b676f4a62da4c"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/4f/5a/597ef5911cb8919efe4d86206aa8b2658616d676a7088f0825ca08bd7cb8/urllib3-1.26.6.tar.gz"
    sha256 "f57b4c16c62fa2760b7e3d97c35b255512fb6b59a259730f36ba32ce9f8e342f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.yml").write <<~EOS
      ---
      AWSTemplateFormatVersion: '2010-09-09'
      Resources:
        # Helps tests map resource types
        IamPipeline:
          Type: "AWS::CloudFormation::Stack"
          Properties:
            TemplateURL: !Sub 'https://s3.${AWS::Region}.amazonaws.com/bucket-dne-${AWS::Region}/${AWS::AccountId}/pipeline.yaml'
            Parameters:
              DeploymentName: iam-pipeline
              Deploy: 'auto'
    EOS
    system bin/"cfn-lint", "test.yml"
  end
end
