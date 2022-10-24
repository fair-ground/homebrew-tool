class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.6.58", revision: "ce702b031d8e045aacb0fdeaf3adc4c3ddc6e523"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.6.58"

    sha256 cellar: :any, arm64_monterey: "81781bd092af7c0353dc8716b3f78801ada7db5f7d5a9a168171fff7be00d5a1"
    sha256 cellar: :any, monterey: "9ebfc5ec0900ad8306d100ca32888fa7ebce63b7b26c34b511d11c8937378659"
    sha256 cellar: :any, x86_64_linux: "58711a82a4ee5732c0e1b6df697b7d990dda408ff9ddc6076bac23f6bff318f9"
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
