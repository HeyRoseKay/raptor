//
// Application+Configure.swift
// RaptorVapor
// https://raptor.build
// See LICENSE for license information.
//

import Vapor
import Raptor

extension Application {
    /// Bootstraps Raptor for server-side rendering of code-defined pages,
    /// without loading content, generating assets, registering routes, or
    /// installing middleware.
    ///
    /// Use this when the host application manages its own routes, middleware,
    /// and assets, and only needs Raptor to render code-defined pages through
    /// `Request.render(_:)`. This is also suitable for running Vapor
    /// in-process inside an iOS application.
    ///
    /// The site's `prepare()` hook is still called so application-level
    /// setup runs as normal.
    ///
    /// - Parameter site: The user's site type.
    public func configure(_ site: some Site, from file: StaticString = #filePath) async throws {
        var mutableSite = site
        self.site = try await mutableSite.configure(from: file)
    }

    /// Bootstraps Raptor for server-side rendering of code-defined pages,
    /// using an explicitly supplied root directory.
    ///
    /// Use this overload when the `#filePath`/`Package.swift` discovery
    /// heuristic is unavailable, such as inside an iOS app bundle.
    ///
    /// - Parameters:
    ///   - site: The user's site type.
    ///   - rootDirectory: The root directory of the project.
    public func configure(_ site: some Site, rootDirectory: URL) async throws {
        var mutableSite = site
        self.site = try await mutableSite.configure(rootDirectory: rootDirectory)
    }
}
