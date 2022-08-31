class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.5.11", revision: "d2cde12f3a9a65ea6438f7bb0c1d5f3fa567c4a2"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.5.11"

    sha256 cellar: :any, arm64_monterey: "e040940e323f82d169bff85c5e32ee22fa67f1291764587d5d042583bfc6bbcb"
    sha256 cellar: :any, monterey: "851eadf7591fa6121c9c028953c25e4aa09b8c6e6bddebebf114fc187796ad2b"
    sha256 cellar: :any, x86_64_linux: "4d8fd76404a94493fde81988a584a75e0cb1f17aac75bff17132088264315b5e"
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
