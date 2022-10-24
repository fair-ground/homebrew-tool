class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.6.57", revision: "6855250bcc4d47c4a67df491efa9d51f2e39c549"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.6.57"

    sha256 cellar: :any, arm64_monterey: "58eb3fda1a8779f6df2704cff221fde593a353dffef97801367eaaa9b698182b"
    sha256 cellar: :any, monterey: "898e193f830a9f8c957f094622c947cb89ad8f6b5ccb6bd2e44ce1fd888c038a"
    sha256 cellar: :any, x86_64_linux: "1699936b38f79e767a828c16e8e3792af38a9ca59e325a76c19f8715f3d19fb7"
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
