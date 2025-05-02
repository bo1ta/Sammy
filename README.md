# Sammy

Sammy is a native iOS client for the [Lemmy](https://join-lemmy.org/) platform, a federated social link aggregator. Built entirely in Swift, it will offer a seamless UX with features like customizable feeds and real-time notifications. This app is not affiliated with LemmyNet or its developers.

## Upcoming Features

- Browse posts and communities across Lemmy instances.
- Smooth, native SwiftUI with dark mode support.
- Real-time updates via Lemmy's WebSocket API.
- Offline caching for posts and comments.

## Pre-installation

- Make sure you have <b>swiftlint</b> installed. [Swiftlint](https://github.com/realm/SwiftLint) is a tool to enforce Swift style and conventions. The easiest way to install it is via [homebrew](https://brew.sh/) with `brew install swiftlint`.
- This project is also equipped with a `swiftformat` configuration. [SwiftFormat](https://github.com/nicklockwood/SwiftFormat) is a code library and command-line tool for reformatting Swift code. You can run `swiftformat .` in the project's root directory to format your code.

## Installation

1. Clone the repo: `git clone https://github.com/bo1ta/Sammy.git`
2. Before running, 
3. Open in Xcode: Sammy.xcodeproj
4. Build and run

## License

Sammy is licensed under the GNU General Public License v3.0 (GPL-3.0). See LICENSE for details.

This app is built from scratch in Swift and does not use any Lemmy source code. It interacts with Lemmy instances via their public APIs. As required by GPL-3.0, the complete source code of Sammy is available in this repository.

## Trademark Notice

"Lemmy" is the name of the open-source platform developed by LemmyNet. Sammy uses "Lemmy" in its documentation to indicate compatibility with the Lemmy platform. This app is an independent project and not endorsed by LemmyNet.

# Contributing

Contributions are welcome! Please read the CONTRIBUTING.md for guidelines. This is a side project, so PR reviews may be sporadic. All contributions must be licensed under GPL-3.0.
