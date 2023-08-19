class CplnK8sCostAnalyzer < Formula
  desc "Control Plane K8s Cost Analyzer"
  homepage "https://controlplane.com"
  url "https://github.com/controlplane-com/k8s-cost-analyzer/archive/refs/tags/v1.0.5.zip"
  sha256 "b6dcd2a829ca9724aac4a0f41d285a9cc9a8995f260ae68663839e7c97fd3755"
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
