class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.4.52", revision: "b7dcdfcaf2cf6aa5d9d95d19a12a7a7b5f718d06"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.4.52"

    sha256 cellar: :any, arm64_monterey: "4c17203f1eb6482d86c25d538aff6f47b5630d746281a3af197492111e5a73a1"
    sha256 cellar: :any, monterey: "0cfbbcf821669c77be7596db64205918cda7a842336f96c23d2cb70cee39cedc"
    sha256 cellar: :any, x86_64_linux: "3fee8490dde3206b202fd3c209122b10c7f6bc82ccf5b133b0820a5ba10ce213"
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
