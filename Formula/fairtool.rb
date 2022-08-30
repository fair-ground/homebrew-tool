class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.5.10", revision: "c1c24d842afda390ab008c636398959553f9a898"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.5.10"

    sha256 cellar: :any, arm64_monterey: "e8bad82302d707121fdaa6a1765d6c496cfb3d145cf71ed96cc78e82279fabf5"
    sha256 cellar: :any, monterey: "eea0ef81db6b01d9c135793bb233cbfbdcd8e56fa6178f134bd7e0dc662a33ec"
    sha256 cellar: :any, x86_64_linux: "2df6d6ab22b04379bd8cf928a6664186cdfb02e2cd5792c3bddf807d0a4c9f13"
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
