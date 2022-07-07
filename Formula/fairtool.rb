class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.4.56", revision: "055f072767a4efad9ceb68ab8ed4bc56ab19a2a2"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.4.56"

    sha256 cellar: :any, arm64_monterey: "138356b405d828a261d52cba71c4312a406d3e0ca58549d9c10ea18934730bd3"
    sha256 cellar: :any, monterey: "550f183578583970df47cff0524d41a3b71855f3ad22f7e2667bc639a3977e1e"
    sha256 cellar: :any, x86_64_linux: "dc5aa49d796185d64c4340eaffebed5303124df378644a16f825c6dcc41b3b53"
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
