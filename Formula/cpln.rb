class Cpln < Formula
  desc "Control Plane CLI"
  homepage "https://controlplane.com"
  if OS.mac?
    url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/1217840798-de56847e/cpln-macos.tgz",
        verified: "https://storage.googleapis.com/artifacts.cpln-build.appspot.com"
    sha256 "3e62fbdaa1a03c5e3468e3cc079211426d9def1e34086d514896f507709b1163"
  else
    url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/1217840798-de56847e/cpln-linux.tgz",
        verified: "https://storage.googleapis.com/artifacts.cpln-build.appspot.com"
    sha256 "0e08aae11e1d832a879b5c9329d6604c180f0e9762b587b0dec989521725e090"
  end
  version "2.0.0"
  license "GPL-3.0-only"

  def install
    bin.install "cpln"
    bin.install "docker-credential-cpln"
    # `docker-credential-cpln` is a tool required by the CLI allowing Docker
    # to authenticate to your org's private image registry in Control Plane.
  end

  test do
    # Run the CLI binary with the "--version" flag
    assert_match "2.0.0", shell_output("#{bin}/cpln --version")

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
