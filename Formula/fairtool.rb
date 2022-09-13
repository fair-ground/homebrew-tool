class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.5.20", revision: "159d1100950424b872f345eb181fda071725b863"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.5.20"

    sha256 cellar: :any, arm64_monterey: "8bd278fe5aa25a253d2aaee6f27b9048377fae79bbdebbfdfb56afed8de805f4"
    sha256 cellar: :any, monterey: "c55a49dc4d5adba65229ba5cac6715e2a932e641dc326abc92f09e4160bfdd5b"
    sha256 cellar: :any, x86_64_linux: "501a41e41eafd07bc1e812b811740863824ce9ac7d4fed94558c5411cb9842d3"
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
