// swift-tools-version:5.5
import PackageDescription

var exclude: [String] = []

#if os(Linux)
// Linux doesn't support CoreML, and will attempt to import the coreml source directory
exclude.append("coreml")
#endif

let package = Package(
    name: "transcribewhisper",
    products: [
        .library(name: "transcribewhisper", targets: ["transcribewhisper"])
    ],
    targets: [
        .target(name: "transcribewhisper", dependencies: [.target(name: "whisper_cpp")]),
        .target(name: "whisper_cpp",
                exclude: exclude,
                cSettings: [
                    .define("GGML_USE_ACCELERATE", .when(platforms: [.macOS, .macCatalyst, .iOS])),
                    .define("WHISPER_USE_COREML", .when(platforms: [.macOS, .macCatalyst, .iOS])),
                    .define("WHISPER_COREML_ALLOW_FALLBACK", .when(platforms: [.macOS, .macCatalyst, .iOS]))
                ]),
        .testTarget(name: "WhisperTests", dependencies: [.target(name: "transcribewhisper")], resources: [.copy("TestResources/")])
    ],
    cxxLanguageStandard: CXXLanguageStandard.cxx11
)

