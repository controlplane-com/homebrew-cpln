class CplnK8sCostAnalyzer < Formula
  desc "Control Plane K8s Cost Analyzer"
  homepage "https://controlplane.com"
  url "https://github.com/controlplane-com/k8s-cost-analyzer/archive/refs/tags/v1.0.4.zip"
  sha256 "7490e2b8212e3248a188543b3ef047ccd0b895925c58c8d3652ed9f97795130f"
  version "1.0.4"
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
    assert_match "1.0.4", shell_output("#{bin}/cpln-k8s-cost-analyzer --version")
  end
end
