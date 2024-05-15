class Cpln < Formula
  desc "Control Plane CLI"
  homepage "https://controlplane.com"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/1292227631-3efbcff0/cpln-macos-arm64.tgz",
          verified: "https://storage.googleapis.com/artifacts.cpln-build.appspot.com"
      sha256 "6d900666580f4c76e98162c0cf71385849227bce5ac506419adabd0b7c1b1638"
    else
      url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/1292227631-3efbcff0/cpln-macos.tgz",
          verified: "https://storage.googleapis.com/artifacts.cpln-build.appspot.com"
      sha256 "bcb6a4b3bf993a42604a09ec412fe144f4e0cdbea2ec3e8ed5240258785aafc0"
    end
  else
    url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/1292227631-3efbcff0/cpln-linux.tgz",
        verified: "https://storage.googleapis.com/artifacts.cpln-build.appspot.com"
    sha256 "18ae91bb79fac4ac211ce4fdd7c8e007dac1730dd9e2cf35e042f9a79907ab3e"
  end
  version "2.2.0"
  license "GPL-3.0-only"

  def install
    bin.install "cpln"
    bin.install "docker-credential-cpln"
    # `docker-credential-cpln` is a tool required by the CLI allowing Docker
    # to authenticate to your org's private image registry in Control Plane.
  end

  test do
    # Run the CLI binary with the "--version" flag
    assert_match "2.2.0", shell_output("#{bin}/cpln --version")

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
