class Cpln < Formula
  desc "Control Plane CLI"
  homepage "https://controlplane.com"
  if OS.mac?
    url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/1098041012-6f8a926e/cpln-macos.tgz",
        verified: "https://storage.googleapis.com/artifacts.cpln-build.appspot.com"
    sha256 "0542afcbf91c1a72f15da72df08edf2ec230587aee8091f1e291847d465068b8"
  else
    url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/1098041012-6f8a926e/cpln-linux.tgz",
        verified: "https://storage.googleapis.com/artifacts.cpln-build.appspot.com"
    sha256 "c7ff95cc2031dacc558829e9976aa8c6a83385593eadd39c5d270a25e179c24c"
  end
  version "1.5.2"
  license "GPL-3.0-only"

  def install
    bin.install "cpln"
    bin.install "docker-credential-cpln"
    # `docker-credential-cpln` is a tool required by the CLI allowing Docker
    # to authenticate to your org's private image registry in Control Plane.
  end

  test do
    # Run the CLI binary with the "--version" flag
    assert_match "1.5.2", shell_output("#{bin}/cpln --version")

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
