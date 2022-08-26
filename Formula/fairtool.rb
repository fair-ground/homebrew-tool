class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.5.6", revision: "6d154e9503008613bceda1a8cfe5440bd1e795cb"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.5.6"

    sha256 cellar: :any, arm64_monterey: "7f3a4c443a03a611f58ce73b979797084a38236d347300c1cf287dd313f0b4cd"
    sha256 cellar: :any, monterey: "46c8a5f09fd7d313571d77e945199918512b09c3f599f45326a807b14cca5596"
    sha256 cellar: :any, x86_64_linux: "bbea62ded9fd71cf73844d0e530bd1836e3d47be6e82325304685011dbde31c8"
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
