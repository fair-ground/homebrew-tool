class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.7.23", revision: "cacdb831c8666c821032fbfab48c7a756936692d"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.7.23"

    sha256 cellar: :any, arm64_monterey: "f54d847631deeb31c5332587cbe299618f7de8e35d720cc77371242719eda03a"
    sha256 cellar: :any, monterey: "58b483a61ac8fe1dd4efca1e70847d8fd1add2a79fca7e08836545ff89b6972f"
    sha256 cellar: :any, x86_64_linux: "10a111fed63f802e93cc5f6b70e4b0dbfb463156c026e88e112b42c348eb8d83"
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
