class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.5.14", revision: "f39d1ac83cd0ad5dec1ab4cdd7bbc509cfd2a3d2"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.5.14"

    sha256 cellar: :any, arm64_monterey: "5449bd5f4d15aa4571e6778cf36a32f3d9cf3e4e2da40c92db7c63dcae03b9f1"
    sha256 cellar: :any, monterey: "c86a5c0e1fb99a3925fe3deb6dea0dee1b8f4d8bd57247f95379e72bbb2164ba"
    sha256 cellar: :any, x86_64_linux: "d734ed739a6cf7ff8122045dda65fcd04438d3673e7c704d7e4466aeb49cc047"
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
