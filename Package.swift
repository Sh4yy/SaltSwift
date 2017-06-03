// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "SaltSwift",
    dependencies : [
     .Package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", majorVersion: 0)
    ]
    
)
