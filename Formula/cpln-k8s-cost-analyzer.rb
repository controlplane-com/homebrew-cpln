class CplnK8sCostAnalyzer < Formula
  desc "Control Plane K8s Cost Analyzer"
  homepage "https://controlplane.com"
  url "https://github.com/controlplane-com/k8s-cost-analyzer/archive/refs/tags/v1.0.0.zip"
  sha256 "6e6e945a7ae108f9b153fd644d29f2b3afa40ea4048010cf07754ca0d08e673b"
  version "1.0.0"
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
    assert_match "1.0.0", shell_output("#{bin}/cpln-k8s-cost-analyzer --version")
  end
end
