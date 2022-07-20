class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.4.69", revision: "b565f5bdd8f9cc7043880fcfc5248c9c6ae7dcb3"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.4.69"

    sha256 cellar: :any, arm64_monterey: "dbe67a60359ce1f4f7a7ddba7ce9826b6af27c3b7d9e2de7b773413fd75168fa"
    sha256 cellar: :any, monterey: "d77a21c4a0075bc27edf3b523ab9682f6434cf1d2c389fa0a619e852f8bffc5f"
    sha256 cellar: :any, x86_64_linux: "fa01be35226cccd4d1d949aa23418c067e6684fbbe63037485a05e9e82117d35"
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
