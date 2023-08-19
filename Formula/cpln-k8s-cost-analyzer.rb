class CplnK8sCostAnalyzer < Formula
  desc "Control Plane K8s Cost Analyzer"
  homepage "https://controlplane.com"
  url "https://github.com/controlplane-com/k8s-cost-analyzer/archive/refs/tags/v1.0.5.zip"
  sha256 "11a0e8e622988b4449074fe0ee50d8dc7c81d6c90de1aba35eee310fa94dbb01"
  version "1.0.5"
  license "GPL-3.0-only"

  depends_on "python"
  depends_on "pyinstaller"
  
  def install
    # Install dependencies from requirements.txt
    system "pip", "install", "-r", "requirements.txt"

    # Build the binary using PyInstaller
    system "pyinstaller", "--onefile", "main.py", "--name", "cpln-k8s-cost-analyzer"

    # Install generated binary
    bin.install "dist/cpln-k8s-cost-analyzer"
  end

  test do
    # Run the binary with the "--version" flag
    assert_match "1.0.5", shell_output("#{bin}/cpln-k8s-cost-analyzer --version")
  end
end
