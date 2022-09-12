class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.5.17", revision: "dd274ad1f2ca435e3ca5fefab5d91f923665e7e1"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.5.17"

    sha256 cellar: :any, arm64_monterey: "16716a4a93624b57d6839450267bfecfe1ddd2e9be4f93118b7aa5a5cf329afe"
    sha256 cellar: :any, monterey: "f1d676f9cf2b0c6074bc3d554a16bf2ca102dac8aba7ea35c1dc196489967802"
    sha256 cellar: :any, x86_64_linux: "a996a40672c7020cf2575fbee86edccc5faa9a6d555b68be10756200795df6e7"
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
