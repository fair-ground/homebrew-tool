class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.4.75", revision: "2b06b3216be17f2ba84ad7cf41e3bfc89f315ff3"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.4.75"

    sha256 cellar: :any, arm64_monterey: "367fb8e3b05499d64fef85ee0691d9ddb376aacf1fef7bacbd1981429d46b0dc"
    sha256 cellar: :any, monterey: "78a2891213af179d0d0bdb98573055cbc2c0ca6475e1bbb36892a5d4df0c0c59"
    sha256 cellar: :any, x86_64_linux: "80f3487accf8ed9d2ace033105a83bd4fa5807f8b8b640cc3e5e551c155d5782"
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
