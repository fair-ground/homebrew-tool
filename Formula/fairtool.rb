class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.5.12", revision: "ed436ca54ec5f9f475c9c27d12bcde01706f81b4"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.5.12"

    sha256 cellar: :any, arm64_monterey: "dbae0a586f4deaa06b16fdb84622aec2348d46af1f71828bd1f3ddb75a815590"
    sha256 cellar: :any, monterey: "4e24f9e2903331745a4e0c52d4fce384663c7ec7972c375751d0cbf34a521efd"
    sha256 cellar: :any, x86_64_linux: "bba0f23337180b3b8f67c226b5906abbee0aa67a00f7bf305cc1fc7e9f9405ea"
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
