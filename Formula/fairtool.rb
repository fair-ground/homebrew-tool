class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.4.54", revision: "91bb29859e951cacc57a430bc263d1c6efabadaf"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.4.54"

    sha256 cellar: :any, arm64_monterey: "72ee7618ace789a35f081ef9e0d9803c9e73de94871259ad1413d4cba2f7c5ff"
    sha256 cellar: :any, monterey: "83ee2e845d611172b49b2f7eb309802b55f04c0f571ca7ff260f8d1aff4dc034"
    sha256 cellar: :any, x86_64_linux: "0b52661498ac85296d391cd21e64909dfce11e0a6a87bed72e8af710001accc8"
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
