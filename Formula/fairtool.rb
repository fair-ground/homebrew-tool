class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.8.22", revision: "be9a4572ffc2a7a7963888bace6271a002b783c1"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.8.22"

    sha256 cellar: :any, arm64_monterey: "4823cdb50ebd44bf63896e65c48a8b9d8bdcfd7c684c5a0bf174551aef06b40a"
    sha256 cellar: :any, monterey: "7f732ffff4168e3eb955eaef1ec06956d2a9d17f7faaddbdf3b193d42b4c9827"
    sha256 cellar: :any, x86_64_linux: "fcf6c379b7f3ac207b1c59410353c8ef823005accd1196a3429900f872194af8"
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
