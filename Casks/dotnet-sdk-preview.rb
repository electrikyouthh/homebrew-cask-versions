cask "dotnet-sdk-preview" do
  arch arm: "arm64", intel: "x64"

  on_intel do
    version "7.0.200,f8383fbb-f5d9-4a0b-95fb-2c65a0e5c050,38bf5bf31fdcede0eab86ba84b54ed81"
    sha256 "9802784506f3a8493ae01c5c2881c69ca6575b5f3621220ff8632e16cba500e9"
  end
  on_arm do
    version "7.0.200,a4baeeb9-efb8-446a-a0db-4f907121b9c7,ad72727dada1c2788fbfd1df08b5b5a7"
    sha256 "45034c706516120eff5fd37d0cbbb58361cb9a50f07e4a0ba88b656a8bb8cb21"
  end

  url "https://download.visualstudio.microsoft.com/download/pr/#{version.csv[1]}/#{version.csv[2]}/dotnet-sdk-#{version.csv[0]}-osx-#{arch}.pkg"
  name ".NET SDK"
  desc "Developer platform"
  homepage "https://www.microsoft.com/net/core#macos"

  livecheck do
    url "https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/#{version.major_minor}/releases.json"
    regex(%r{/download/pr/([^/]+)/([^/]+)/dotnet-sdk-v?(.+)-osx-#{arch}\.pkg}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map do |match|
        "#{match[2]},#{match[0]},#{match[1]}"
      end
    end
  end

  conflicts_with cask: [
    "dotnet",
    "dotnet-sdk",
    "dotnet-preview",
  ], formula: "dotnet"
  depends_on macos: ">= :mojave"

  pkg "dotnet-sdk-#{version.csv[0]}-osx-#{arch}.pkg"
  binary "/usr/local/share/dotnet/dotnet"

  uninstall pkgutil: [
              "com.microsoft.dotnet.*",
              "com.microsoft.netstandard.pack.targeting.*",
            ],
            delete:  [
              "/etc/paths.d/dotnet",
              "/etc/paths.d/dotnet-cli-tools",
            ]

  zap trash: [
    "~/.dotnet",
    "~/.nuget",
  ]
end
