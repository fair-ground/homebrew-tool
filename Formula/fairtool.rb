class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.7.11", revision: "440da4f6d7a81b904ae3be6d7b234a9f82ed94a5"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.7.11"

    sha256 cellar: :any, arm64_monterey: "95a6e00c4f5fee1c59d83eed125206ee5e3d13aa46339b0241ea40dd1d8ef29e"
    sha256 cellar: :any, monterey: "ab9ceaf6854eb1144ddc1c5de3acb949ab7d868b4bdbd90e485b841a549180b2"
    sha256 cellar: :any, x86_64_linux: "3d8101509579252f4a3cc671fa19390e7b0ba7447271db5cee6a29296e218882"
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
