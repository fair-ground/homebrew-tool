class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.8.24", revision: "afd6a74513c5063dbbff66ed845c494902de21eb"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.8.24"

    sha256 cellar: :any, arm64_monterey: "0ac4f19ac213c655602d88e6d92bee5da012af0c337a51aeb157ee85973c435f"
    sha256 cellar: :any, monterey: "49860120fca3c99d50d8a9d26685565199d6edee39851d9cf0917336efaff689"
    sha256 cellar: :any, x86_64_linux: "2c40033d8e88ccfb3adf9246faaf76544936fe2b9735b6b14b3f011c5c514c9f"
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
