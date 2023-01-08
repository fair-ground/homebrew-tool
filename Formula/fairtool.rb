class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.8.35", revision: "5a37ddbacf2a75dc037e23da4c4e5dae9eade8dc"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.8.35"

    sha256 cellar: :any, arm64_monterey: "46dfb9c5ba673a6de237febd2d08290ca68157ba996be1682eb4838d7f35c223"
    sha256 cellar: :any, monterey: "de5a9872478c5dd5796341cb907faee499622864fb66b9446997d4dc8e661ede"
    sha256 cellar: :any, x86_64_linux: "795017c28c575297381a5aac58341d0f700af90d31ac4f9f0e0f6f14f3396a9b"
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
