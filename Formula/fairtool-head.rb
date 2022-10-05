class FairtoolHead < Formula
  desc "Manage an ecosystem of ipa app sources"
  homepage "https://fair-ground.org"
  url "https://github.com/fair-ground/Fair.git", branch: "main"
  version "latest"
  license "AGPL-3.0"
  head "https://github.com/fair-ground/Fair.git", branch: "main"

  uses_from_macos "swift"

  def install
    system "swift", "build", "--product", "fairtool", "-c", "debug", \
      "--disable-sandbox", "-Xswiftc", "-cross-module-optimization"
    bin.install ".build/debug/fairtool" => "fairtool-head"
  end

  test do
    assert_match /^fairtool [0-9]+\.[0-9]+\.[0-9]+$/, shell_output("#{bin}/fairtool-head version 2>&1").strip
    if OS.mac?
      shell_output("#{bin}/fairtool-head app info /System/Applications/Calendar.app | jq -e '.[].entitlements[0][\"com.apple.security.app-sandbox\"]'")
    end
  end
end
