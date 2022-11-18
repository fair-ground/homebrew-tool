class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.7.26", revision: "d1051f4ab3287c5d053bca7f0417d509a329ff2a"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.7.26"

    sha256 cellar: :any, arm64_monterey: "9f08057d0dfdf52acd96a82cf67410ce2273e075dda5b4172d48fc5d3492e598"
    sha256 cellar: :any, monterey: "93ce02b8c4444e2ff3e96326ca7976450c0e2be98c5f1921618bb87a743bd1d6"
    sha256 cellar: :any, x86_64_linux: "44b31580ede290d5395d2a116e9783cf8210ed51dc6ecf63eb99eccea1adf937"
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
