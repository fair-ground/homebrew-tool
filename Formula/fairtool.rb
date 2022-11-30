class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.7.50", revision: "876851418434f7a2de5143ed378caec7f7da3ab4"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.7.50"

    sha256 cellar: :any, arm64_monterey: "a7cd9910c444a103e51a36c7d1caadb5929694eca8e72335f2af1df5481bc2ef"
    sha256 cellar: :any, monterey: "48fdcc672090cb9d29267b0dec4b4ff9b03619de8d8bf063c487c8455991f5a6"
    sha256 cellar: :any, x86_64_linux: "1835980b50a04c0eb610e0085ecfaf2a5728852841438d3b88142d62b4bfe986"
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
