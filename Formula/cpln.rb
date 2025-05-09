class Cpln < Formula
  desc "Control Plane CLI"
  homepage "https://controlplane.com"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/1809643413-4654d3d2/cpln-macos-arm64.dmg",
          verified: "storage.googleapis.com"
      sha256 "38841636c4dd701f6baa5b7537f76a8ffbaabf59fa5888a7c50e0a12a7d4ded6"
    else
      url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/1809643413-4654d3d2/cpln-macos-x64.dmg",
          verified: "storage.googleapis.com"
      sha256 "4e4f130d60475e8c034ba007df71ab728ff14b22259caec492e7fabe7c435263"
    end
  else
    url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/1809643413-4654d3d2/cpln-linux.tgz",
        verified: "storage.googleapis.com"
    sha256 "f4e851be18a349f1d10d829eddaca7a0e706ed7ff6cd0a8c4189b2fa11137ae4"
  end
  version "3.5.2"
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
    assert_match "3.5.2", shell_output("#{bin}/cpln --version")

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
