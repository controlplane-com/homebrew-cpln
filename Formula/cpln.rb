class Cpln < Formula
  desc "Control Plane CLI"
  homepage "https://controlplane.com"
  if OS.mac?
    url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/1173109536-37647d23/cpln-macos.tgz",
        verified: "https://storage.googleapis.com/artifacts.cpln-build.appspot.com"
    sha256 "85d45558d98f0ba54fd21f52cdf33171e6b546b3330213096e93d6d361dad9c0"
  else
    url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/1173109536-37647d23/cpln-linux.tgz",
        verified: "https://storage.googleapis.com/artifacts.cpln-build.appspot.com"
    sha256 "4b602ccc728fc21586d1b73d6bd21375355e2f25babdf0c242577da79d3c1e22"
  end
  version "1.6.0"
  license "GPL-3.0-only"

  def install
    bin.install "cpln"
    bin.install "docker-credential-cpln"
    # `docker-credential-cpln` is a tool required by the CLI allowing Docker
    # to authenticate to your org's private image registry in Control Plane.
  end

  test do
    # Run the CLI binary with the "--version" flag
    assert_match "1.6.0", shell_output("#{bin}/cpln --version")

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
