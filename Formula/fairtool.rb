class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.6.71", revision: "7730669ef221d56b99b011dd1df122216c552314"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.6.71"

    sha256 cellar: :any, arm64_monterey: "e911db4afbf4200897479b5242707c3460b34555f7165bdb5dca6068f783cd3f"
    sha256 cellar: :any, monterey: "967ab2562194feeb06f22642767e5810a0ee176b8df5299be39e5b6e19bcd5d4"
    sha256 cellar: :any, x86_64_linux: "be5d6cea8ee09dbc0469f13dab1f2b982c2eec7b53e5169a512f8d18db1c76f8"
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
