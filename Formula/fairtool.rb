class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.4.72", revision: "e7b9a5521c3ed04667b62fa00aab6808a6acb3b7"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.4.72"

    sha256 cellar: :any, arm64_monterey: "fb0d01c79b9cd227b64f9533dc5e2a9c335869092ec87db6b06eb443fc14fee4"
    sha256 cellar: :any, monterey: "41c7609ba70437ce8263a290beec23f072555fe71c152d27cf3200416bb732fd"
    sha256 cellar: :any, x86_64_linux: "dc124af2e0f6259ba45a7b65df657a41d9aad638a0afe63fede8cf194010ecc9"
  end

  head "https://github.com/fair-ground/Fair.git", branch: "main"

  uses_from_macos "swift"

  def install
    system "swift", "build", "--product", "fairtool", "-c", "release",
           "-Xswiftc", "-cross-module-optimization", "--disable-sandbox",
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
