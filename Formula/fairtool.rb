class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.9.1", revision: "070ba4629433d62d66f71b5f74323128e300dc20"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.9.1"

    sha256 cellar: :any, arm64_monterey: "250c9d59fe544ec57216e8a550448b5f9ee9910a88fe40352945ff961d5cd98b"
    sha256 cellar: :any, monterey: "eb3475e5d5048e5ac9112fa09a70c73e5e6b822b05df6d3759e73ba2d626db89"
    sha256 cellar: :any, x86_64_linux: "42089513203fdfcce20a62e1ee24705f73b19e9459576253dcd9d40348d585b3"
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
