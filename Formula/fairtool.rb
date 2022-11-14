class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.7.16", revision: "8ca94853bae3f1e92fd25a2537a229520ff5ab58"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.7.16"

    sha256 cellar: :any, arm64_monterey: "7d9f03a3e8a091166558eada6b9f5c47db5d15d2ca831c1e0b1dac24b36241eb"
    sha256 cellar: :any, monterey: "30829aaca4fbc5113a2ddd7780aea478553bf627cbf9f01ee2a4426028e7a1c0"
    sha256 cellar: :any, x86_64_linux: "92cc58f4af9a9853a0b625281abed6a7e87aa1555efc7bcca65a21335aae7bcb"
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
