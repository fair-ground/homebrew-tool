class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.4.74", revision: "64f857607737e8e10fd8ce7d18f18a91fb187390"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.4.74"

    sha256 cellar: :any, arm64_monterey: "ef30a4d9d96fe578bff80027c823a217233c271e3e9031c40458b147f3752ef7"
    sha256 cellar: :any, monterey: "b4c0082077d33ad614f383d9ab114d41fefac499de5f684ce8f4fd25b34c687f"
    sha256 cellar: :any, x86_64_linux: "0c4453a1ac924f64d1635ca6e6e061a45a274e4c5ee1761a9cfee93601e91bc1"
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
