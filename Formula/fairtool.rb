class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.9.0", revision: "02ff35901f428b0736abbc4616777cd16b7a08b6"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.9.0"

    sha256 cellar: :any, arm64_monterey: "3c61543aad811a2b24a72563492c1d34e7149cb70a1ca2001fc67cfc5ade7bf1"
    sha256 cellar: :any, monterey: "123d4574f48d9b9611618fe77450a8ae0811c4f84c9baf2b6cd4db474a965bdd"
    sha256 cellar: :any, x86_64_linux: "574d10f561cf8159c9fa2d2898232d9eb34bbfa8db239cd80bf81d4d480d2793"
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
