class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.6.69", revision: "8f23da8609c72d936b4833aba3446860e627b546"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.6.69"

    sha256 cellar: :any, arm64_monterey: "614d0ee58a1d7dc7da1796ff267015d83af4a3f48f900030abcf24be9f6e56c7"
    sha256 cellar: :any, monterey: "e979a7559e82a422d9f4302c214715afb6f659d9a36cc63a71c2d981229f8ca4"
    sha256 cellar: :any, x86_64_linux: "e6d1056a390c29f722f842fd3da4f65e8b0aab216834f240cd443680a9fb3834"
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
