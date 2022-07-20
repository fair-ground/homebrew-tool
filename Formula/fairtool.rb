class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.4.67", revision: "a12c1f6fa3915144cfd79b8487bcdb61b43e21b1"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.4.67"

    sha256 cellar: :any, arm64_monterey: "513b3071f6b08e4b5a7f5bfcd8a2627e0c971b857937cfed15263f23c94714b7"
    sha256 cellar: :any, monterey: "c335eb9167a0dbc95de4840f00cf477a0bb581351bc92216b36f672c58d3cb82"
    sha256 cellar: :any, x86_64_linux: "c3e5a896f307214b739cc0693fa3be39bba4a2095c7fe9ead54d82660a0dbb38"
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
