class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.5.1", revision: "eb3c20ae28074c95507390d275c57089d182c37a"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.5.1"

    sha256 cellar: :any, arm64_monterey: "6912cda600d258dd47cbf25a47e12a73fa5921bdf7b86ef02a9e04df5eec1f65"
    sha256 cellar: :any, monterey: "dc4d786777ad35dc9d5418b893d57a3ecf0c6d5df3dab4f24dae85c6ad4ac404"
    sha256 cellar: :any, x86_64_linux: "c367ef5b0a0e454d0a02b7504d25815a94bec9c511c9fceb147f7a37862ffc45"
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
