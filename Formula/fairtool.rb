class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.6.44", revision: "1a416a2fb2a0fcf22e4c996aa750588b3def7a21"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.6.44"

    sha256 cellar: :any, arm64_monterey: "ec9abffeae8f057c3ee1c4223db166234c9143f4ddbd7dd37a3eca5e122de774"
    sha256 cellar: :any, monterey: "27ea77f9dec20db8d90d58b16ff191d3c3ca5245fc5d1bed69f07e1504bc67e0"
    sha256 cellar: :any, x86_64_linux: "14bd579c3934b70a3ebdb7733303105aacf3d76bdea65eacf26d1ff534c19663"
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
