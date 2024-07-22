class Cpln < Formula
  desc "Control Plane CLI"
  homepage "https://controlplane.com"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/1382977409-d78b5070/cpln-macos-arm64.dmg",
          verified: "storage.googleapis.com"
      sha256 "26d3d382d4cc9f47cb8de80bcc5f3f1a02ed43effb948a1ce8d4eb05d3b51a40"
    else
      url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/1382977409-d78b5070/cpln-macos-x64.dmg",
          verified: "storage.googleapis.com"
      sha256 "23505a373f7d2634e2092c0c12580e8f1a3317d14b02a4330f0b7002c5274c8a"
    end
  else
    url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/1382977409-d78b5070/cpln-linux.tgz",
        verified: "storage.googleapis.com"
    sha256 "ae89cdfea0c2e6030eef7cc9993509787456e40d48470b2fa0367db1dfceb00e"
  end
  version "3.0.0"
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
    assert_match "3.0.0", shell_output("#{bin}/cpln --version")

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
