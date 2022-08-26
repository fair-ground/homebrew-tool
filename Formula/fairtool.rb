class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.5.4", revision: "e4b0c7b0016f50e330bf8f913ecc99ad4f1ee204"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.5.4"

    sha256 cellar: :any, arm64_monterey: "a52b0ed5c3cd0d37942431b4638153362139badd3d9cf269a0eba05fded49852"
    sha256 cellar: :any, monterey: "25406f0d6b079f940a22c643980c1a607c1a1934ae964db815bcd6776586abee"
    sha256 cellar: :any, x86_64_linux: "918fd30c1a256958d15abe9853249613ce14484906ba9ee74a784f628837abd6"
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
