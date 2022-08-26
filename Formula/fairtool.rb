class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.5.5", revision: "14331fca9f8d476529f803a2f0b3d63855589934"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.5.5"

    sha256 cellar: :any, arm64_monterey: "0d73c508ff18675ad29fa53303cbf8517f6140c051af86a6b671c00bc21ee3ca"
    sha256 cellar: :any, monterey: "819e3345fc7e51d3683389b0d1f6708aec68a405a8426f2c699a575d47596dcd"
    sha256 cellar: :any, x86_64_linux: "55c7f0a6d9654dde8ff2256d5270e5c58f7b34c19ebe3099fb717997a02af413"
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
