class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.8.30", revision: "a0bfa96e947e20f7b84c466803f62de72dea460b"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.8.30"

    sha256 cellar: :any, arm64_monterey: "e52f5d8e38b7a69843608bd1e21227829111cd03bcbca74b616f918b53c50363"
    sha256 cellar: :any, monterey: "0a633c3a1b967df09377428da38ff85c49f98934398049928018ce7b88285367"
    sha256 cellar: :any, x86_64_linux: "e082d0b33dd6f7e710bd27cdfd042d1ca9c726618aec52c7077dcf4d20e7d4c9"
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
