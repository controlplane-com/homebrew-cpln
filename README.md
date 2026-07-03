# Control Plane - Homebrew Tap

## Overview
This is the official [Control Plane](https://controlplane.com) Homebrew [Tap](https://docs.brew.sh/Taps).

## Installation

Run the following command to add the tap to your Homebrew taps.

```bash
brew tap controlplane-com/cpln
```

On Homebrew 6.0 and later, third-party taps must be explicitly trusted before their formulae can be installed. Run the following command to trust this tap (older Homebrew versions can skip this step):

```bash
brew trust controlplane-com/cpln
```

To install a package, you need to run the following command:

```bash
brew install package_name
```

If you skip the trust step on Homebrew 6.0+, `brew install` fails with `Error: Refusing to load formula ... from untrusted tap controlplane-com/cpln.` Running the `brew trust` command above resolves it.

## Available Packages

```bash
# Formulae

brew install cpln
brew install cpln-k8s-cost-analyzer
```

## Update

```bash
brew update && brew upgrade
```
