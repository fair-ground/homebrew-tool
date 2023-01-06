class Fairtool < Formula
  desc "Tools for managing an ecosystem of app sources"
  homepage "https://github.com/fair-ground/Fair"
  url "https://github.com/fair-ground/Fair.git", tag: "0.8.32", revision: "f0708b543ade41d0efa17b716fe5fb2602d456bb"
  license "AGPL-3.0"

  bottle do
    root_url "https://github.com/fair-ground/Fair/releases/download/0.8.32"

    sha256 cellar: :any, arm64_monterey: "dbd5e1811f01624e087d1e9330e9f6dabbf600c55ef81a0c86df638926919801"
    sha256 cellar: :any, monterey: "b5e7152aee9e1184574156c387b928402732cef22d648759d0ebf096625a5494"
    sha256 cellar: :any, x86_64_linux: "cc2474669efddae9b58be95e516d5130341ff4f458c046ec09224bb68e2102f0"
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
