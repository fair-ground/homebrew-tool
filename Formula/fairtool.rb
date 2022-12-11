class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.8.9", revision: "376880a626c4c1f0e48d3f28b18028b9f79f0fbc"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.8.9"

    sha256 cellar: :any, arm64_monterey: "6ca7f04ddf2a54bd235bbdfd6bfbaddc4fc3c93c74ce6978afd7a0854c0369e7"
    sha256 cellar: :any, monterey: "476bbe5b75824bc44c4e97098aa4897ca0cdab97367865aed0ca3ad6ef72cf76"
    sha256 cellar: :any, x86_64_linux: "be1aa8e64908dd426c8c316c4cb4510e5f8bf33b35eecd9fb6dadcf3accf2b9b"
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
