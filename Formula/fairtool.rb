class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.5.21", revision: "5fdece66c0156208eebaf4150fb0c63e7ba733e9"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.5.21"

    sha256 cellar: :any, arm64_monterey: "660974efdbdd90f2c4726577de6de7247423cb1b3634f8858d4f1302e489308a"
    sha256 cellar: :any, monterey: "c86c1826515e74fe63dd0ec309aae21e8a358a62e2904baaba45175130f53675"
    sha256 cellar: :any, x86_64_linux: "4ed5ae80874468bc208622da7673e653f03b6a6c343ff4469a706f36f9b686e0"
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
