class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.8.17", revision: "43c8a0649612accdc6605c49299fdec5b9bff580"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.8.17"

    sha256 cellar: :any, arm64_monterey: "f1ff02f8ca13076f14f51fb7a52d8ae7a3b68980f2993eb0c4a75bf9e6bf037c"
    sha256 cellar: :any, monterey: "183847286d4d0778e9ceabdd036b40146c19e236f299f92f4eadf11c73fd2675"
    sha256 cellar: :any, x86_64_linux: "bd41fe465b135ad48e52a1e78d5f7783649bc20d3f571a99f7d9f1745f3eaf08"
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
