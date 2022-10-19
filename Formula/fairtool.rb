class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.6.50", revision: "34fd71940af68feaee121a1f4a7def7c67b210b5"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.6.50"

    sha256 cellar: :any, arm64_monterey: "418fdc13ca6fdc2e84284dd5f1afdc36e7fb592525195cc335b29cd7a03d009a"
    sha256 cellar: :any, monterey: "4538cc04cdfc6b95cafac4b5a3718a15d30510ebc12c4ca620827fc2adb5df0c"
    sha256 cellar: :any, x86_64_linux: "6edcec89605c89e68d4fab516a5bf71a212584e0315ebfc2fb2999aa93bf4163"
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
