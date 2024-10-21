// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ImageMagickSwift",
    products: [
        .library(
            name: "ImageMagickSwift",
            targets: ["ImageMagickSwift"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ImageMagickSwift",
            dependencies: [],
            path: "./Sources",
            cSettings: [
                .headerSearchPath("../include"),
                .define("HAVE_MAGICKWAND", to: "1"),
                .define("MAGICKCORE_HDRI_ENABLE", to: "1"),
                .define("MAGICKCORE_QUANTUM_DEPTH", to: "16")
            ],
            linkerSettings: [
                .linkedLibrary("MagickWand-7.Q16HDRI"),
                .linkedLibrary("MagickCore-7.Q16HDRI"),
                .unsafeFlags(["-L", "/opt/homebrew/Cellar/imagemagick/7.1.1-39/lib"])
            ]
        ),
    ]
)
