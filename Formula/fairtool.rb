class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.7.21", revision: "519a12a2ef10d42eab8e3b160a75b9196eeeb2dc"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.7.21"

    sha256 cellar: :any, arm64_monterey: "cb0c2e138ec0b3ccf4896ba2432e70e40b0fbcd803eef623f25bd5b52b0798f5"
    sha256 cellar: :any, monterey: "9d0859cbf72c46a380be7292f02620077872bd117d12190544c866816152bc2f"
    sha256 cellar: :any, x86_64_linux: "148e508b9e3dff0a9345bc1e6522f6395f6bb98f87a499889a8148ff0491a839"
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
