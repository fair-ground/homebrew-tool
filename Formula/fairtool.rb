class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.6.46", revision: "cedfb105164cadebcccebdf9e438f1ff755a1957"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.6.46"

    sha256 cellar: :any, arm64_monterey: "7be49a4a78112f71e368ff2e508df24c18edeb8882ace58f524c00afcbd0c995"
    sha256 cellar: :any, monterey: "a5dd1b42c6e9af21a84d1863777931b5d4bf69df678d67d8d77e4ad53de768fe"
    sha256 cellar: :any, x86_64_linux: "0272040505b43b5aca21d495ebb9d2d600b29b02b76bce7397a4f39b5833af07"
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
