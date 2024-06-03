class CplnK8sCostAnalyzer < Formula
  desc "Control Plane K8s Cost Analyzer"
  homepage "https://controlplane.com"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/controlplane-com/k8s-cost-analyzer/releases/download/v1.1.1/k8s-cost-analyzer-macOS-arm64"
      sha256 "fd2d44b92a408514e6f67d12d95ef7039a44537b9906409e08733f1b8fdaf746"
    else
      url "https://github.com/controlplane-com/k8s-cost-analyzer/releases/download/v1.1.1/k8s-cost-analyzer-macOS-x64",
      sha256 "4f483f6da4c9f4439d3772bbe33592ec41fda4cc53897f5ee38ed95bef417cbe"
    end
  else
    url "https://github.com/controlplane-com/k8s-cost-analyzer/releases/download/v1.1.1/k8s-cost-analyzer-linux"
    sha256 "ec5d4421573a752b15f80d7faa4f38073c5e42174f082cfa7d734b3c0d2e274b"
  end
  version "1.1.1"
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
    assert_match "1.1.1", shell_output("#{bin}/cpln-k8s-cost-analyzer --version")
  end
end
