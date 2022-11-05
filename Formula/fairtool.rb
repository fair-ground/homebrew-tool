class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.7.9", revision: "39fd28a68b57aa073fd8da05aa02b0a2de75d635"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.7.9"

    sha256 cellar: :any, arm64_monterey: "053825bf004310df6e8a7c5d3c59bb7278368b2f4e26ca329c7d92c0891ed03e"
    sha256 cellar: :any, monterey: "cef7acb3bdcd3d6e7002bdf69e04bef8d5da4bba3f7e4b85c737c4edfe169ca9"
    sha256 cellar: :any, x86_64_linux: "cddfc7d43b2266ccfdd29a1b730fb9fa7506443b1cbf564100a9ed1e557b5baf"
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
