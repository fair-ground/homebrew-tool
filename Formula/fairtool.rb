class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.8.13", revision: "89e42a844c8466e8a659f03e1cfa8cbd5044ffb3"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.8.13"

    sha256 cellar: :any, arm64_monterey: "46a94d646b4a421f93ee640477e12692ed6ce15bff917b7098b1560f030c224a"
    sha256 cellar: :any, monterey: "5378ac355a5113afd323d2c91307b05d257d589d369ebfbbb0972fd803e25994"
    sha256 cellar: :any, x86_64_linux: "da05c30edea7bc304bbed0a9dd22e4d00c9172bdedc0f70a4f470de82ee56269"
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
