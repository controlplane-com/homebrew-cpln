class Cpln < Formula
  desc "Control Plane CLI"
  homepage "https://controlplane.com"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/2310819839-998d9349/cpln-macos-arm64.dmg",
          verified: "storage.googleapis.com"
      sha256 "e060717aa1984489e52dba11fd37979442896b59ba6885f9a7b04ec043c3c8a8"
    else
      url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/2310819839-998d9349/cpln-macos-x64.dmg",
          verified: "storage.googleapis.com"
      sha256 "b410486d532eb0ed6564b98d016f506c498e5e2259389f32ebaef930864c6bcb"
    end
  else
    url "https://storage.googleapis.com/artifacts.cpln-build.appspot.com/binaries/cpln/2310819839-998d9349/cpln-linux.tgz",
        verified: "storage.googleapis.com"
    sha256 "abcc1abcc6728f86c754bc0e91d473ed196c251ef6e2394a6a887266b7f890ad"
  end
  version "3.9.0"
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
    assert_match "3.9.0", shell_output("#{bin}/cpln --version")

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
