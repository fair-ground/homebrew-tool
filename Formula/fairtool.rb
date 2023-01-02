class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.8.26", revision: "c26e2de682d03c7d0433bb2b1d1384274b865011"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.8.26"

    sha256 cellar: :any, arm64_monterey: "a1394d03c71b92af2c962c1e453332c9272c1bfb965f061bfb71613951f98f11"
    sha256 cellar: :any, monterey: "4d0620ffb1d3672ce6c9d367a721188429b434eedecb147cc9592b28667f8f7c"
    sha256 cellar: :any, x86_64_linux: "e4d3b3fc0f6cf87977f817efcf575da5d3396439e49295c8f40302ffa7394de8"
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
