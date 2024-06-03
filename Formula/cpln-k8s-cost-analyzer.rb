class CplnK8sCostAnalyzer < Formula
  desc "Control Plane K8s Cost Analyzer"
  homepage "https://controlplane.com"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/controlplane-com/k8s-cost-analyzer/releases/download/v1.1.0/k8s-cost-analyzer-macOS-arm64"
      sha256 "c257dab8256ac84fc8c2e8de07a0a8f3943226fab9d98cea1f3e61ef031a8a88"
    else
      url "https://github.com/controlplane-com/k8s-cost-analyzer/releases/download/v1.1.0/k8s-cost-analyzer-macOS-x64",
      sha256 "eb0ecac6caf8034aa63dc2e821898a896619d373b903b463ec72c4f0235a83e3"
    end
  else
    url "https://github.com/controlplane-com/k8s-cost-analyzer/releases/download/v1.1.0/k8s-cost-analyzer-linux"
    sha256 "87af3a9c7919a89e5d16a87f715e02bcef6b34faea0507c8634e001dec3e12d8"
  end
  version "1.1.0"
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
    assert_match "1.1.0", shell_output("#{bin}/cpln-k8s-cost-analyzer --version")
  end
end
