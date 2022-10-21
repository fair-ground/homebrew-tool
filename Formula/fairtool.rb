class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.6.54", revision: "25e4c4224e98a9fa18e253a03911e8bf1674c40e"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.6.54"

    sha256 cellar: :any, arm64_monterey: "b2f39d6f067216dbc099f3400e0f07895e3c76b7d528d899b7ee935eed2830f9"
    sha256 cellar: :any, monterey: "82d61605a559e3d731bc7d1ecd88c7e7dc3fb7640ee6b55767650bf21ad2c365"
    sha256 cellar: :any, x86_64_linux: "6a5b12158aa0be870621a8450e0a6d662679a08c04bf8678d67c951062df944c"
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
