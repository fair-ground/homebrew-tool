class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.5.18", revision: "2050fdd43f9e0aff6cf177cb24191e43b64f5a73"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.5.18"

    sha256 cellar: :any, arm64_monterey: "ac631b968f98aac4d99125900e43d33fa617f2fca458bb7297fac857724757d3"
    sha256 cellar: :any, monterey: "8b726717aeb50b212bd012034cf45d359e28a2f37f67ac7e7d33d05c8192bd05"
    sha256 cellar: :any, x86_64_linux: "458e61c8758d747beb827da7123b172940394b66ff197fe1d3947719fa7ffd00"
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
