class Cpln < Formula
  desc "Control Plane CLI"
  homepage "https://controlplane.com"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/2860837467-0c576f10/cpln-macos-arm64.tgz",
          verified: "storage.googleapis.com"
      sha256 "b67325834da519eefdfe1c2525a2263e4c41b7e948f476edf899f5ec771f3487"
    else
      url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/2860837467-0c576f10/cpln-macos-x64.tgz",
          verified: "storage.googleapis.com"
      sha256 "501017334321972620332b347aab8751307dad77d314d4c2ee3feae461aec034"
    end
  else
    url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/2860837467-0c576f10/cpln-linux.tgz",
        verified: "storage.googleapis.com"
    sha256 "7633a5af33b5ea8744abe601fce1a55a26400662ddb12e601a8882d3e1cd759d"
  end
  version "3.17.1"
  license "GPL-3.0-only"

  def install
    bin.install "cpln"
    bin.install "docker-credential-cpln"

    # `docker-credential-cpln` is a tool required by the CLI allowing Docker
    # to authenticate to your org's private image registry in Control Plane.
  end

  test do
    # Run the CLI binary with the "--version" flag
    assert_match "3.17.1", shell_output("#{bin}/cpln --version")

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
