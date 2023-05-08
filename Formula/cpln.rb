class Cpln < Formula
  desc "Control Plane CLI"
  homepage "https://controlplane.com"
  url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/844733757-ba7245dd/cpln-macos.tgz",
      verified: "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/"
  version "0.0.89"
  sha256 "26d10eacd3773ac16944f3880cd8fbee198eadd5e8018336d04187cf48855aa4"
  license "GPL-3.0-only"

  def install
    bin.install "cpln"
    bin.install "docker-credential-cpln"
    # `docker-credential-cpln` is a tool required by the CLI allowing Docker
    # to authenticate to your org's private image registry in Control Plane.
  end

  test do
    # Run the CLI binary with the "--version" flag
    assert_match "0.0.89", shell_output("#{bin}/cpln --version")

    # Run the CLI binary with the "--help" flag
    assert_match "Control Plane Corporation", shell_output("#{bin}/cpln --help")

    # Attempt to create a CPLN profile
    test_profile = "test-profile"
    test_org = "test-org"
    test_gvc = "test-gvc"

    system "#{bin}/cpln", "profile", "create #{test_profile}", "--org #{test_org}", "--gvc #{test_gvc}"
    assert_match test_profile, shell_output("#{bin}/cpln profile get")

    # Set profile as default
    system "#{bin}/cpln", "profile", "set-default", test_profile
    assert_match "*", shell_output("#{bin}/cpln profile get")
  end
end