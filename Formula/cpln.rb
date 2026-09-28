class Cpln < Formula
  desc "Control Plane CLI"
  homepage "https://controlplane.com"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/2889524368-e1b7f2b9/cpln-macos-arm64.tgz",
          verified: "storage.googleapis.com"
      sha256 "db492cc396eac736abf7a755d0665907cc68be47e0aac9793bd04ba812e51d0c"
    else
      url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/2889524368-e1b7f2b9/cpln-macos-x64.tgz",
          verified: "storage.googleapis.com"
      sha256 "32983638ac5cbd835c179ab4198807a4ee60eaa17c24cd5a6556749510526d0a"
    end
  else
    url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/2889524368-e1b7f2b9/cpln-linux.tgz",
        verified: "storage.googleapis.com"
    sha256 "9204369e57527ae497ca502dad7a9c9ec7f584eca9104cad436980ec14d930ca"
  end
  version "3.17.2"
  license "GPL-3.0-only"

  def install
    bin.install "cpln"
    bin.install "docker-credential-cpln"

    # `docker-credential-cpln` is a tool required by the CLI allowing Docker
    # to authenticate to your org's private image registry in Control Plane.
  end

  test do
    # Run the CLI binary with the "--version" flag
    assert_match "3.17.2", shell_output("#{bin}/cpln --version")

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
