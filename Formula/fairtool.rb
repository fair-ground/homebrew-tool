class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.4.71", revision: "8c239ee5e2980f2f493b7ec699848a776a96d3c0"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.4.71"

    sha256 cellar: :any, arm64_monterey: "9b23759af99d400152c6fb33ace768f377e175acc8ef53a61e5d9119e005be8a"
    sha256 cellar: :any, monterey: "dc453a34740daa233f186b9193fa931cf48527741bec2404a47a05cb30d0863c"
    sha256 cellar: :any, x86_64_linux: "57832ce9042d26f6c397b4af0bf30e91ee394b79ea5b1d033589b391cdd1c9b8"
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
