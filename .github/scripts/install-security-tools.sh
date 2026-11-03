#!/usr/bin/env bash
# Installs gitleaks and OSV-Scanner from pinned releases, verifying SHA-256 (SECX-07, SECX-18).
set -euo pipefail
GITLEAKS_VERSION=8.30.1
OSV_VERSION=2.7.0
dest="${RUNNER_TEMP:-/tmp}/sectools"
mkdir -p "$dest" && cd "$dest"

curl -fsSL -o gl.tgz "https://github.com/gitleaks/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz"
curl -fsSL -o gl.sums "https://github.com/gitleaks/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_checksums.txt"
grep "gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz" gl.sums | sed 's|  .*|  gl.tgz|' | sha256sum -c -
tar -xzf gl.tgz gitleaks

curl -fsSL -o osv-scanner "https://github.com/google/osv-scanner/releases/download/v${OSV_VERSION}/osv-scanner_linux_amd64"
curl -fsSL -o osv.sums "https://github.com/google/osv-scanner/releases/download/v${OSV_VERSION}/osv-scanner_SHA256SUMS"
grep " osv-scanner_linux_amd64$" osv.sums | sed 's|  .*|  osv-scanner|' | sha256sum -c -
chmod +x osv-scanner gitleaks

echo "$dest" >> "${GITHUB_PATH:-/dev/null}"
