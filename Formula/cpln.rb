class Cpln < Formula
  desc "Control Plane CLI"
  homepage "https://controlplane.com"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/3094526373-b939ed1d/cpln-macos-arm64.tgz",
          verified: "storage.googleapis.com"
      sha256 "6a78d576b4056571e249e74abe63cbba98ea45f5eeea9e4d20915445668d1a25"
    else
      url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/3094526373-b939ed1d/cpln-macos-x64.tgz",
          verified: "storage.googleapis.com"
      sha256 "965472126cedba28295da9b55ef8b4bf93a7f826502a02ed272ef15af06add9b"
    end
  else
    url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/3094526373-b939ed1d/cpln-linux.tgz",
        verified: "storage.googleapis.com"
    sha256 "7d759838979ca73e91b0421e4f7b3364cb69cf50ace537ac500e2ad6f4f435f5"
  end
  version "3.19.0"
  license "GPL-3.0-only"

  def install
    bin.install "cpln"
    bin.install "docker-credential-cpln"

    # `docker-credential-cpln` is a tool required by the CLI allowing Docker
    # to authenticate to your org's private image registry in Control Plane.
  end

  test do
    # Run the CLI binary with the "--version" flag
    assert_match "3.19.0", shell_output("#{bin}/cpln --version")

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
