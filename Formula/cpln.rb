class Cpln < Formula
  desc "Control Plane CLI"
  homepage "https://controlplane.com"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/2847639947-3237df0e/cpln-macos-arm64.tgz",
          verified: "storage.googleapis.com"
      sha256 "64b38c47d2ce455afc665985724cbd678f82b8bb1cdb254d3f477bc113e0afae"
    else
      url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/2847639947-3237df0e/cpln-macos-x64.tgz",
          verified: "storage.googleapis.com"
      sha256 "564e42c6f36cd7b381991561981d3e340eb0521d34a49a6712e880cb9661a6e0"
    end
  else
    url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/2847639947-3237df0e/cpln-linux.tgz",
        verified: "storage.googleapis.com"
    sha256 "ee5810666f0ac49a5067ae61704ea28dfaf95ce89b231047dc952dd3f3435b14"
  end
  version "3.17.0"
  license "GPL-3.0-only"

  def install
    bin.install "cpln"
    bin.install "docker-credential-cpln"

    # `docker-credential-cpln` is a tool required by the CLI allowing Docker
    # to authenticate to your org's private image registry in Control Plane.
  end

  test do
    # Run the CLI binary with the "--version" flag
    assert_match "3.17.0", shell_output("#{bin}/cpln --version")

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
