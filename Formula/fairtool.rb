class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.4.76", revision: "7e2d1cc64d2551025d091420e267adada8f1bd9a"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.4.76"

    sha256 cellar: :any, arm64_monterey: "c3f6781217ffcdaf0001f9ec6d74adec34fd3258d9c61ca36b301ec2ea93287f"
    sha256 cellar: :any, monterey: "b1a3d67ce94d680c01dc774437f39c5e6fba5583249b6582ad737d45eee5bdee"
    sha256 cellar: :any, x86_64_linux: "d6f80a9f416f57409d82f893000b8aa307704d983107eedd7f9974409353342f"
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
