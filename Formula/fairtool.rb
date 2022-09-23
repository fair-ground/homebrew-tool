class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.6.4", revision: "7db0148935f0e92ff0f8cd2a04422a9f5e105d9c"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.6.4"

    sha256 cellar: :any, arm64_monterey: "2207182798ec61847aec612a0be4e51aad1e98097b3c968f54277ea12512fa88"
    sha256 cellar: :any, monterey: "1603c2c0feefc26ff64fb9d2623d1b280b61d70a1c38e9e34f7e3d0bf1142cb0"
    sha256 cellar: :any, x86_64_linux: "9ad7200c5d7206a15f81df26bb4b9735633ed3befc80ab8e49790e352f9dfb1f"
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
