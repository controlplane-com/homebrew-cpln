class Cpln < Formula
  desc "Control Plane CLI"
  homepage "https://controlplane.com"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/2267695279-891d592b/cpln-macos-arm64.dmg",
          verified: "storage.googleapis.com"
      sha256 "026079ae8706392aaa11e928480836e2ce4675225a6896f38950f2776dbdfd3c"
    else
      url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/2267695279-891d592b/cpln-macos-x64.dmg",
          verified: "storage.googleapis.com"
      sha256 "12c7415803ba8eca38dcffd612ad4271423743b07bdceeaf546848361cb5adbb"
    end
  else
    url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/2267695279-891d592b/cpln-linux.tgz",
        verified: "storage.googleapis.com"
    sha256 "fadc084925779cbe017b781fa4acf2d02a80d0fc5a22b2ec6b3c7d7e304b8b1d"
  end
  version "3.8.2"
  license "GPL-3.0-only"

  def install
    if OS.mac?
      dmg_mountpoint = "#{buildpath}/dmg"
      staging_dir = "#{buildpath}/staging"

      # Create a directory to stage the files
      mkdir staging_dir

      # Mount the DMG file
      system "hdiutil", "attach", cached_download, "-mountpoint", dmg_mountpoint
      
      # Copy the files from the DMG to the staging directory
      cp "#{dmg_mountpoint}/cpln", staging_dir
      cp "#{dmg_mountpoint}/docker-credential-cpln", staging_dir

      # Unmount the DMG file
      system "hdiutil", "detach", dmg_mountpoint

      # Install the files from the staging directory
      bin.install "#{staging_dir}/cpln"
      bin.install "#{staging_dir}/docker-credential-cpln"
    else
      bin.install "cpln"
      bin.install "docker-credential-cpln"
    end

    # `docker-credential-cpln` is a tool required by the CLI allowing Docker
    # to authenticate to your org's private image registry in Control Plane.
  end

  test do
    # Run the CLI binary with the "--version" flag
    assert_match "3.8.2", shell_output("#{bin}/cpln --version")

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
