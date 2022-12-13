class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.8.11", revision: "ae3653f497b8703b63f8ea3c32e563dba22749bf"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.8.11"

    sha256 cellar: :any, arm64_monterey: "8bec565c7658eaadaf17ee0cc2ab5e871493431d7555223e10b41550c984bcf0"
    sha256 cellar: :any, monterey: "63194a8e23dea99bc9d8517ce065ce5e0794ff7fe83b2416583f7523b3ff93f8"
    sha256 cellar: :any, x86_64_linux: "25e48fd7c56c5e9fbab3b25c9f622afa7a13bfbdac450ee574a07867c1d80999"
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
