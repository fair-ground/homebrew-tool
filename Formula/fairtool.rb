class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.5.13", revision: "1a8ca91a3b8de16fc1387922f60521ea1b608915"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.5.13"

    sha256 cellar: :any, arm64_monterey: "3acf46dc01a5561a5d1758a64a5c0102718781a882082cef5e9ccfcd05db4fc3"
    sha256 cellar: :any, monterey: "09dd6afb27de65212c61d8c65c3c7269547b2b451df2038323b9e22dc973f055"
    sha256 cellar: :any, x86_64_linux: "e986d0cc0ece3d8454753d0f3701aceecc99b8302b9159d5fa82dd29939d449d"
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
