class CplnK8sCostAnalyzer < Formula
  desc "Control Plane K8s Cost Analyzer"
  homepage "https://controlplane.com"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/controlplane-com/k8s-cost-analyzer/releases/download/v1.1.3/k8s-cost-analyzer-macOS-arm64"
      sha256 "53d6fda6fa23060396a1c1da4932fa82816a8a6c83718a3ad4851b8cce0cfe66"
    else
      url "https://github.com/controlplane-com/k8s-cost-analyzer/releases/download/v1.1.3/k8s-cost-analyzer-macOS-x64"
      sha256 "8adce7aa5af2f85381a30e24dc265aba9c00391a6304a4327be0f78054cdf6c2"
    end
  else
    url "https://github.com/controlplane-com/k8s-cost-analyzer/releases/download/v1.1.3/k8s-cost-analyzer-linux"
    sha256 "2febb195d951220605eb1e56bc8828461407f88d9c0962a0b149759a81748c8e"
  end
  version "1.1.3"
  license "GPL-3.0-only"
  
  def install
    if OS.mac?
      if Hardware::CPU.arm?
        bin.install "k8s-cost-analyzer-macOS-arm64" => "cpln-k8s-cost-analyzer"
      else
        bin.install "k8s-cost-analyzer-macOS-x64" => "cpln-k8s-cost-analyzer"
      end
    else
      bin.install "k8s-cost-analyzer-linux" => "cpln-k8s-cost-analyzer"
    end
  end

  test do
    # Run the binary with the "--version" flag
    assert_match "1.1.3", shell_output("#{bin}/cpln-k8s-cost-analyzer --version")
  end
end
