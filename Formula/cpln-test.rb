class Cpln < Formula
  desc "Control Plane CLI"
  homepage "https://controlplane.com"
  if OS.mac?
    url "https://storage.googleapis.com/binaries/cpln/binaries/cpln/1051708608-baffad49/cpln-macos.tgz",
        verified: "https://storage.googleapis.com/binaries/cpln"
    sha256 "7ee7301147bbf16de65b509fcb6ff6728ae9b030099e50051832d200cc1d3d5a"
  else
    url "https://storage.googleapis.com/binaries/cpln/binaries/cpln/1051708608-baffad49/cpln-linux.tgz",
        verified: "https://storage.googleapis.com/binaries/cpln"
    sha256 "65daeb2b293238b83b3228a775066795b3d6d2ffec9a5647d18c8055ab2c0d91"
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
