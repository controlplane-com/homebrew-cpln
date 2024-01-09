class CplnK8sCostAnalyzer < Formula
  desc "Control Plane K8s Cost Analyzer"
  homepage "https://controlplane.com"
  if OS.mac?
    url "https://github.com/controlplane-com/k8s-cost-analyzer/releases/download/v1.0.5/k8s-cost-analyzer-macOS"
    sha256 "4c65492fa59d1451baba4842982c58438b9a51f282f20e9a27010f97d7d94db2"
  else
    url "https://github.com/controlplane-com/k8s-cost-analyzer/releases/download/v1.0.5/k8s-cost-analyzer-linux"
    sha256 "87af3a9c7919a89e5d16a87f715e02bcef6b34faea0507c8634e001dec3e12d8"
  end
  version "1.0.5"
  license "GPL-3.0-only"
  
  def install
    if OS.mac?
      bin.install "k8s-cost-analyzer-macOS" => "cpln-k8s-cost-analyzer"
    else
      bin.install "k8s-cost-analyzer-linux" => "cpln-k8s-cost-analyzer"
    end
  end

  test do
    # Run the binary with the "--version" flag
    assert_match "1.0.5", shell_output("#{bin}/cpln-k8s-cost-analyzer --version")
  end
end
