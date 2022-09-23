class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.6.1", revision: "6783ca8be74043f8482d12b2b24a39c70deee1bd"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.6.1"

    sha256 cellar: :any, arm64_monterey: "46e2a14bc2547510c3f405de56edaaf819e82c34cc2056971ba58e6ee640d921"
    sha256 cellar: :any, monterey: "5de533472d12f03e177c7313a7a4e4deab6c600477ca29373c33ff5f21c97d52"
    sha256 cellar: :any, x86_64_linux: "da073975e99227066ca8c57a15db57d6a63be0d4a36a91e01296471696526e40"
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
