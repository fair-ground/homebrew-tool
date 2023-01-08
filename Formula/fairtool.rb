class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.8.34", revision: "e91d24cb063e9fd38c58db87fbc7a189d791e005"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.8.34"

    sha256 cellar: :any, arm64_monterey: "d34c390513175108731e01f7c383af060d37ea93f876b37a944de46936439303"
    sha256 cellar: :any, monterey: "a55a0faf3cda475d408a0a0943d862404f665f6f39dc66b295f2c5840ea21868"
    sha256 cellar: :any, x86_64_linux: "b565b03ef0de7ece9a061ffee9afdfd03cb8769b9b0ada6a32697d9a9f3200e1"
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
