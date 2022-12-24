class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.8.21", revision: "1291542fd06717f3b14ae5b1e4475685dff6cc81"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.8.21"

    sha256 cellar: :any, arm64_monterey: "71e2697089ecc584f2c559dd247a76a56eaad26462b04f3409ce2b941256014b"
    sha256 cellar: :any, monterey: "9204e8dffccd17f9bcf5b2f0ee7e3a435cb875299718a9323920fb61792f0bea"
    sha256 cellar: :any, x86_64_linux: "f46c4dba92f596b68a8d3aa203ce3840bbd5227164671bb3e38ae7f26bf064c2"
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
