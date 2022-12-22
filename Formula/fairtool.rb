class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.8.18", revision: "c1bfed0156c7523e8ea2100c4cb8f22ae1853249"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.8.18"

    sha256 cellar: :any, arm64_monterey: "7608733fd56773f40aa546b6266da5d8cdf17255d8de80cf87b16e70ad2ff014"
    sha256 cellar: :any, monterey: "ac6e2be1bc89fe749ab55a58eabc9088d1ecfa390a00231cecd9019eccdcb476"
    sha256 cellar: :any, x86_64_linux: "9662714b9d4f780c934687d0ae1343833bdabb371312a1ee4ebdd21e6e14b7de"
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
