class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.6.67", revision: "24024bf14b0f13ed8030cfc883d10dda5407780a"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.6.67"

    sha256 cellar: :any, arm64_monterey: "9f44329f89c67ff97faff01cc73ecb51611c07d659a68eac389baa91f5cc18a1"
    sha256 cellar: :any, monterey: "22a9f7aa298eb59797ae39af6006982af5a4864788baaf6b3a86348f95d3566e"
    sha256 cellar: :any, x86_64_linux: "e0bf69c6aad1c0e853ed76a15eee6c087d76d1515947e5ecfcfb5428009f9e19"
  end

  head "https://github.com/fair-ground/Fair.git", branch: "main"

  uses_from_macos "swift"

  def install
    system "swift", "build", "--product", "fairtool", "-c", "release", "--disable-sandbox",
           *(ENV["HOMEBREW_FAIRTOOL_ARCH"] ? ["--arch", ENV["HOMEBREW_FAIRTOOL_ARCH"]] : [])
    bin.install ".build/release/fairtool"
  end

  test do
    assert_match (/^fairtool [0-9]+\.[0-9]+\.[0-9]+$/), shell_output("#{bin}/fairtool version 2>&1").strip
    if OS.mac?
      shell_output("#{bin}/fairtool app info /System/Applications/Calendar.app \
        | jq -e '.[].entitlements[0][\"com.apple.security.app-sandbox\"]'")
    end
  end
end
