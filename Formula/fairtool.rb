class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.7.48", revision: "fbc1c7ce03a40a72f1a3b32dfeee180a81d198a0"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.7.48"

    sha256 cellar: :any, arm64_monterey: "0302b26db1217bcc841b27e672c07aafccad08f37f6e3943a774e5e687459206"
    sha256 cellar: :any, monterey: "26c1124d1bd6a3d6ee2144be9bf0250d61578a13e5620fe897ab539df2ea5bf4"
    sha256 cellar: :any, x86_64_linux: "53ca7c02db02c08595b9207f01cc0716ba12e55c4c86edcc551ad48b004216e7"
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
