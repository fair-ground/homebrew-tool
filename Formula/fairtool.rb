class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.7.7", revision: "cf2cc10ef21db1c91a3b0f3185d09bd56e50141a"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.7.7"

    sha256 cellar: :any, arm64_monterey: "cf539ce48ee041b1595a81c7e03d0176534b466d7590c9a157159a9c872dc7bc"
    sha256 cellar: :any, monterey: "7355dd1a013be88089d162d394b9a094f41a8250bb0b3402281d59db9eed4918"
    sha256 cellar: :any, x86_64_linux: "8004418e149a898e903de9dc34cf049c38c6b6f0aed3556e660f6bb255d884ab"
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
