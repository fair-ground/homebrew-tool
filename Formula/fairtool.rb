class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.7.27", revision: "409fc20a8c9541d6c8f0210964ba844cf2b87811"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.7.27"

    sha256 cellar: :any, arm64_monterey: "fc93a6cdaa00f182ad753760f8325129311a9156b758fffa9e582a2333e85df0"
    sha256 cellar: :any, monterey: "c4b369e0bd9839aa41ec50624b8c3f8105d38fafc813c36847e3c6825968c424"
    sha256 cellar: :any, x86_64_linux: "838bef2785d832d139b2a24d4d39db3ee5a9186961fa2e9568afe362777e3b1a"
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
