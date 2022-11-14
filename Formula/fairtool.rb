class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.7.19", revision: "79ea030d0ff201a8c276b96d7263e20383efd199"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.7.19"

    sha256 cellar: :any, arm64_monterey: "d0a02a4ca730a7a228d1d13005f2c88b721cc7320036be3109732fd8f8810705"
    sha256 cellar: :any, monterey: "49cf8e84437e7ae2c10b3579f94313d6d8e2fc0a2dc0ad48ddd234933f8e7fd5"
    sha256 cellar: :any, x86_64_linux: "403d154a3655829374fda6c5c4fc7ee6b1bc22fa74b93c8d1c40e74269f6c155"
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
