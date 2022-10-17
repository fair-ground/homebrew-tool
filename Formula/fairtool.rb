class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.6.45", revision: "d4000f2237748d8480c5e5dffcc90e008f90f2cb"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.6.45"

    sha256 cellar: :any, arm64_monterey: "267e9fe7110ae5ffb667da03cc4725329ee24addcc367bc885c64ca8960338d8"
    sha256 cellar: :any, monterey: "54a230c1b8b8e1f58ab2581c322fa37df6c54c5ef6deee6138ccc4c1b39deb51"
    sha256 cellar: :any, x86_64_linux: "b7d7aa4d82e2fb1fab9a25370368a5c47818dc4f4e6d108d32e9e7a90cca5102"
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
