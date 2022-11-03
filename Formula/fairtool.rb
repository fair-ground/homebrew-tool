class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.7.1", revision: "effeb2e36a9bd08278e7d5f434fff359a8749f28"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.7.1"

    sha256 cellar: :any, arm64_monterey: "2073c61f29dc4992494ebfe804a0787989c83369b3d0a9830cf482a6a41a91e7"
    sha256 cellar: :any, monterey: "bf9c74536243656e2cd54746c57e2a41f62a7ec481266bc7e6bb17e2b0fba965"
    sha256 cellar: :any, x86_64_linux: "0016314fd42ebdfcbc5dfef253fe8963ce94f69bc1bda4154b6826ffde6e9a91"
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
