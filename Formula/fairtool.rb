class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.6.51", revision: "d078218f8185f613b07a0373cadfa4811a421319"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.6.51"

    sha256 cellar: :any, arm64_monterey: "680de0f9fcacdbfb56aee83235779f559fe5fd322a0f7b10c24f4ba841bd2f67"
    sha256 cellar: :any, monterey: "650b08a8064dd97b20d2552a1b8ce4b26c3c9a6de0899ee9e5c0e5d54a13f3a9"
    sha256 cellar: :any, x86_64_linux: "b678bc27bb968c726e1ec64adeb6d62448052dc2c2c9b109b958fe43f2806f5d"
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
