class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.5.2", revision: "ed028e57bf52d970ac28dbc1244357c94f620101"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.5.2"

    sha256 cellar: :any, arm64_monterey: "d2256f3ab62e96510d6271aa8620104fd0ac8e5141fa21740ea69b49af1d4b65"
    sha256 cellar: :any, monterey: "e3b57a3ae2c31036d53e8bd0d39fc897e41ffc551e8f32b265e58d9ff5def3b9"
    sha256 cellar: :any, x86_64_linux: "bc194fd0d8d41ba5ad2ff7725e755383182f443a6b0ae725bcc466fbfad08019"
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
