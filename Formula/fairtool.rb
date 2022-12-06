class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.8.0", revision: "77e913d6656134ed27150775d6e1d672f6dcfdcd"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.8.0"

    sha256 cellar: :any, arm64_monterey: "28580da57433697660e18be76f2cea5077fece66cf37878b539187ea02e6d18e"
    sha256 cellar: :any, monterey: "c9da81bbb2d42ab5f6e2d547555b153fd5c13a234abbd248612c91f4aaa8515c"
    sha256 cellar: :any, x86_64_linux: "e2fa7287b3a3091fbdd4b18bcf17d7b4cece2772ec8f26df43fb7151626d7aa3"
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
