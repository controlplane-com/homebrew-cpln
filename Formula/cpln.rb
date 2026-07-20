class Cpln < Formula
  desc "Control Plane CLI"
  homepage "https://controlplane.com"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/2689740445-cfc00727/cpln-macos-arm64.dmg",
          verified: "storage.googleapis.com"
      sha256 "3d518ef80bfca40461f202f257be67bb2c033bfd1eca62bca80e282a3254ffce"
    else
      url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/2689740445-cfc00727/cpln-macos-x64.dmg",
          verified: "storage.googleapis.com"
      sha256 "d7262d286b6af4af2fc38c8ac33214649f1ce9b8d1097ac673258099975de0f5"
    end
  else
    url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/2689740445-cfc00727/cpln-linux.tgz",
        verified: "storage.googleapis.com"
    sha256 "c202809c20e7973d562d5fbe3175da2b14304785ebbdb1743685cbf0d4c245fb"
  end
  version "3.14.0"
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
    assert_match "3.14.0", shell_output("#{bin}/cpln --version")

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
