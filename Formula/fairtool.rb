class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.8.20", revision: "74fa618b4fc0c879e7e007132615d551e72a0b89"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.8.20"

    sha256 cellar: :any, arm64_monterey: "13e1083acb73ff54cdb60d8aff7f043af8064d671e7b1a1f3d1dbb0abdfae357"
    sha256 cellar: :any, monterey: "2cfa6d802a5f4c46cf57cc6c8281e1caadc4d56db17b8d9de6ab6cf00c42dd57"
    sha256 cellar: :any, x86_64_linux: "ab6c58b4bc39a9bcd65b2e834f0be3cd7aad98287476cc0117fc0accf4c5ffbf"
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
