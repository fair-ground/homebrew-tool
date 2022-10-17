class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.6.43", revision: "dbe286c4348ae4d200ddbdd2b48f3860cb936453"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.6.43"

    sha256 cellar: :any, arm64_monterey: "5e0130f46482703bba50366f7686b0f0f9020c089abd4aa1c76a57aed2ee62bc"
    sha256 cellar: :any, monterey: "a33002ad29fa88ac024f116595d0525cceff6486b2f5496ed76c9671544ecb17"
    sha256 cellar: :any, x86_64_linux: "391ce6b8cc61434d9016634e66eea5709b906e6b12e6823fcb1c8d6ab9c4f6bf"
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
