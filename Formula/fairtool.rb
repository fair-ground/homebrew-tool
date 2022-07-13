class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.4.62", revision: "0863667f4de7032530d869f040e556429285b431"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.4.62"

    sha256 cellar: :any, arm64_monterey: "1cd70d5b9cf5fe1fd3d068a8867d3a94040381bbc69f7d9f84f84381942c091d"
    sha256 cellar: :any, monterey: "424f076b98a1c1d2621f359232c07975fa42c4fa21e6626f66869bb0df38db1b"
    sha256 cellar: :any, x86_64_linux: "7a4ff0dcc7b6e19766eb122b16b97717a63da6d8b8b228bcd9333c329b9093d2"
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
