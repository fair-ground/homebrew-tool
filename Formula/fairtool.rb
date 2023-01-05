class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.8.31", revision: "fa572b9df1e8cb3efd3eb8a37bc1c2cb9efe33ef"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.8.31"

    sha256 cellar: :any, arm64_monterey: "eea20f1fa3c7ceccd7d6142fc2348b40208716916f6a2868687a3ae30e671f41"
    sha256 cellar: :any, monterey: "f84ad75017ecaa1821d8282714e4ee68aaa22b95532f159a3f60fd46e392d23f"
    sha256 cellar: :any, x86_64_linux: "a4af42d687a54e20b94f647abcd22d6b742fc996c4a97b2b9bede284d73df113"
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
