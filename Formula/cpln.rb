class Cpln < Formula
  desc "Control Plane CLI"
  homepage "https://controlplane.com"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/2921851532-6959edea/cpln-macos-arm64.tgz",
          verified: "storage.googleapis.com"
      sha256 "d93dc667cb75bcdcc5de26f77c3e52e19de68c5dd78554301a949f29e9a200b9"
    else
      url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/2921851532-6959edea/cpln-macos-x64.tgz",
          verified: "storage.googleapis.com"
      sha256 "6b7c4507f02b3adfdb4eec76add2e95123c99d7efc2e74c9d1d26e607ebadf6e"
    end
  else
    url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/2921851532-6959edea/cpln-linux.tgz",
        verified: "storage.googleapis.com"
    sha256 "6a5981bed8a25a62f623f51bf12113047209cc261854dc221d75f982667784ac"
  end
  version "3.18.0"
  license "GPL-3.0-only"

  def install
    bin.install "cpln"
    bin.install "docker-credential-cpln"

    # `docker-credential-cpln` is a tool required by the CLI allowing Docker
    # to authenticate to your org's private image registry in Control Plane.
  end

  test do
    # Run the CLI binary with the "--version" flag
    assert_match "3.18.0", shell_output("#{bin}/cpln --version")

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
