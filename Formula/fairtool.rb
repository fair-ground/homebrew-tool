class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.4.50", revision: "c92c776302e1ca2a5ee2058308d96502b9ded8e1"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.4.50"

    sha256 cellar: :any, arm64_monterey: "ba63a1851bfa48ad80cc1f9b7241c5169fd644185092e95b05fa49e349ec0124"
    sha256 cellar: :any, monterey: "6cf50ee725b36bef1c0de69b821385206774415e0b2303b5bc24b2bb04f5c6ac"
    sha256 cellar: :any, x86_64_linux: "04ac2428dec4a17e9ca036875b669b49f34c60ee8023b5344c01dac8b0578ade"
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
