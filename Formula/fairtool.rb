class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.6.68", revision: "49fd80c767a9a7b8a9842dbfe2fd8c6bb12f1a18"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.6.68"

    sha256 cellar: :any, arm64_monterey: "6f92acede5c57b2fca350d1e26afb75103689d0ad04f7f679d3038149e8c82c1"
    sha256 cellar: :any, monterey: "ac8e8c7d22ce7af8754fad510d7f42e9ca2d109cd08aecd90fa052dbe7d9c7be"
    sha256 cellar: :any, x86_64_linux: "759776ff0ef6a8fde78d0746bd321b5174ddf95b9de225ecb3110eaf14fe63eb"
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
