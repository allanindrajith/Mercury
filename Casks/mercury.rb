cask "mercury" do
  version "0.6.0"
  sha256 "00b47d90cc9c61b62fd3e235ab0f1963a1498d42e2e78cd8de308bd418e8d3a5"

  url "https://github.com/allanindrajith/Mercury/releases/download/v#{version}/Mercury.zip"
  name "Mercury"
  desc "Notch companion that keeps an eye on your AI coding agents"
  homepage "https://github.com/allanindrajith/Mercury"

  # Only the Mac's tags (vX.Y.Z): windows-v…, linux-v… and android-v… are other apps.
  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  # Mercury updates itself from the notch: brew leaves the installed app alone.
  auto_updates true
  depends_on macos: :sequoia

  app "Mercury.app"

  uninstall quit: "com.mercury.app"

  zap trash: [
    "~/Library/Application Support/Mercury",
    "~/Library/Application Support/NotchBuddy",
    "~/Library/Preferences/com.mercury.app.plist",
  ]
end
