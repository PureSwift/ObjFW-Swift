// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ObjFW-Swift",
    products: [
        .library(
            name: "ObjFW",
            targets: ["ObjFW"]
        ),
    ],
    targets: [
        .target(
            name: "ObjFW",
            dependencies: [
                "CObjFW"
            ]
        ),
        .systemLibrary(
            name: "CObjFW",
            pkgConfig: "objfw",
            providers: [
                .brew(["objfw"]),
                .apt(["libobjfw1-dev"])
            ]
        ),
        .testTarget(
            name: "ObjFWTests",
            dependencies: ["ObjFW"],
            linkerSettings: [
                .linkedLibrary("objfwrt", .when(platforms: [.linux, .android, .windows, .openbsd]))
            ]
        )
    ]
)
