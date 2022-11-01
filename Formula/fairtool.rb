class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.6.72", revision: "64ed577475a8810843ff0ac195665c97e28832b2"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.6.72"

    sha256 cellar: :any, arm64_monterey: "53155a69b9f2aece3643fb27f91837939e81c1e42eb5379180f1c83dedd8a5fe"
    sha256 cellar: :any, monterey: "6597501250385d5693361cd75216df92c07b44f0260770a530452dd614583335"
    sha256 cellar: :any, x86_64_linux: "acfad9a26e867d1239080bd9e253a340cf75355ed46318323df6c4b9cad2ff87"
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
