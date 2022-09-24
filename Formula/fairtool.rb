class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.6.7", revision: "003d4634afbd01aff05971bef75d2c0f32cf4cf8"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.6.7"

    sha256 cellar: :any, arm64_monterey: "f7051896a9b7fabb86fbc4ed2a64af6e50db57ec0604504266498b062c80ceef"
    sha256 cellar: :any, monterey: "49e087eee4e9129380d5b40125ddec9eecca47dc42594d8b1d9a04cfeacb8e25"
    sha256 cellar: :any, x86_64_linux: "a49b3fed072317b5dcf6df6cba0edc5bc49fde69ab74e3bc8761dc3ddf866bd9"
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
