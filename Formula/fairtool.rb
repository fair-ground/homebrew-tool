class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.4.64", revision: "d1672ef80e50329c6752f76d6800acdf5a9258ef"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.4.64"

    sha256 cellar: :any, arm64_monterey: "9e29338f85584df8253b848ca0779d0402f4f0b400ed041c7c71b44ab21c49fc"
    sha256 cellar: :any, monterey: "9d1c22198cdcc9ba9b9b026a207d10661e8f69ab6736a5a82119651bc6767d4b"
    sha256 cellar: :any, x86_64_linux: "d4df51689c711149bd290f7e37ccb932f40c924cc5dd81484992fcf78d4622e4"
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
