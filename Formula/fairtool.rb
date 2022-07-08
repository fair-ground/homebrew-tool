class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.4.57", revision: "075e6a57486a53a1aefea0a034e76bd086c1a297"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.4.57"

    sha256 cellar: :any, arm64_monterey: "aea5531df26704129a3b4162f67640ad7f01fb81c4781e0942c0c8172358c45d"
    sha256 cellar: :any, monterey: "9a7eaa0268b39583e258f7f5251b96d6fc83ebc7a2728b76e9a8b4d02fc3b505"
    sha256 cellar: :any, x86_64_linux: "0bf38ada84b4c88008b773600e9cc42cab1f513796ec7328e532dd1ef0c729a3"
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
