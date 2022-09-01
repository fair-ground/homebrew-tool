class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.5.16", revision: "f34f221d6cfcb5a154eec8f687a84d4581e34d1c"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.5.16"

    sha256 cellar: :any, arm64_monterey: "39b4a6aad898db031b8a3fe60e48a31dd3a4827a848094a8d40c1a1879a0d1aa"
    sha256 cellar: :any, monterey: "c6401105fa267edde92726c4071c0f95818c2d8e65ad890c2492d86f600c6d9f"
    sha256 cellar: :any, x86_64_linux: "c832b66df4672186b567ededa3e4365a5b81f765a536efeff17f8c3975a17cf2"
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
