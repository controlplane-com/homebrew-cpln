class Cpln < Formula
  desc "Control Plane CLI"
  homepage "https://controlplane.com"
  if OS.mac?
    url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/binaries/cpln/1479-5f9b0d3/cpln-macos.tgz",
        verified: "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln"
    sha256 "5a57da3cbb19000b5369001d51027bf824cfb8d105fa78f82cd70154e6794f77"
  else
    url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/binaries/cpln/1479-5f9b0d3/cpln-linux.tgz",
        verified: "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln"
    sha256 "1d4cfae739ceee389d305659001d0c3172a0f1a5d9691d55cf66fc40e918ed64"
  end
  version "1.3.1"
  license "GPL-3.0-only"

  def install
    bin.install "cpln"
    bin.install "docker-credential-cpln"
    # `docker-credential-cpln` is a tool required by the CLI allowing Docker
    # to authenticate to your org's private image registry in Control Plane.
  end

  test do
    # Run the CLI binary with the "--version" flag
    assert_match "1.3.1", shell_output("#{bin}/cpln --version")

    # Run the CLI binary with the "--help" flag
    assert_match "Control Plane Corporation", shell_output("#{bin}/cpln --help")

    # Attempt to create a CPLN profile
    test_profile = "test-profile"
    test_org = "test-org"
    test_gvc = "test-gvc"

    system "#{bin}/cpln", "profile", "create", test_profile, "--org", test_org, "--gvc", test_gvc
    assert_match test_profile, shell_output("#{bin}/cpln profile get")

    # Set profile as default
    system "#{bin}/cpln", "profile", "set-default", test_profile
    assert_match "*", shell_output("#{bin}/cpln profile get")
  end
end
