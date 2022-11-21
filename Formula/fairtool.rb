class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.7.41", revision: "207a67448a314351cf8e6cbfe14345f40bdd68c0"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.7.41"

    sha256 cellar: :any, arm64_monterey: "6a634eefa02d8fe8fa95eccf5b5314743d38ad09a864c5cfc9ddc1660efa67fa"
    sha256 cellar: :any, monterey: "ae875097f5eb45ff28f9ab4f9fd93826a7130f77c10e26e77e613ae7e9c646ed"
    sha256 cellar: :any, x86_64_linux: "fef4eb1cc8e51d4d8414aa74d3f01249f1992f3f8820183e05cff363c69a9501"
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
