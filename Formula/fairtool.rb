class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.7.43", revision: "abd3c1cb2c2778c300ab872372b0e95509d5eeaa"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.7.43"

    sha256 cellar: :any, arm64_monterey: "ccab346d8fa7cca1f66e2373e4b9ef9224ab241e4eb08a876df87c86fb3507a6"
    sha256 cellar: :any, monterey: "69c6e1db051334b1548552b9c3b5c688dc70e1a38e9d2664abba6aebc31d299b"
    sha256 cellar: :any, x86_64_linux: "c3284fe84579be4ee8f5dc613f24463583a78a64d8f32e590beed33585409b64"
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
