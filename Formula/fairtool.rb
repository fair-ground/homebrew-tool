class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.6.42", revision: "cd8acd7877f3059e382d821bc4a578644b33cdab"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.6.42"

    sha256 cellar: :any, arm64_monterey: "89eca44b0b86039fd678415f1d295f362f8e6cb9fdbb7254cccf5009c7bbfd01"
    sha256 cellar: :any, monterey: "d97a0ce56c57a91a266d28e02658bffd7a52a459209daef05c7e4f442b960451"
    sha256 cellar: :any, x86_64_linux: "604f50ae4e1426bfe109bc7d3001f56b3ae79f1d76c3cc8c20bf588200a8a4e0"
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
