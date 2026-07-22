//
// Site+Configure.swift
// RaptorVapor
// https://raptor.build
// See LICENSE for license information.
//

extension Site {
    /// Prepares the site for server-side rendering of code-defined pages,
    /// without loading Markdown content or generating any files.
    ///
    /// The site's `prepare()` hook is still called so application-level
    /// setup (API clients, dynamic configuration, etc.) runs as normal.
    ///
    /// - Parameter file: A file used to locate the site's package root.
    mutating func configure(
        from file: StaticString = #filePath
    ) async throws -> ResolvedSite {
        let rootDirectory = try URL.packageDirectory(from: file)
        return try await configure(rootDirectory: rootDirectory)
    }

    /// Prepares the site for server-side rendering of code-defined pages,
    /// using an explicitly supplied root directory.
    ///
    /// Use this overload when the `#filePath`/`Package.swift` discovery
    /// heuristic is unavailable, such as inside an iOS app bundle.
    ///
    /// - Parameter rootDirectory: The root directory of the project.
    mutating func configure(rootDirectory: URL) async throws -> ResolvedSite {
        let environment = EnvironmentValues(
            rootDirectory: rootDirectory,
            site: self.context,
            allContent: []
        )

        let renderingContext = RenderingContext(
            site: context,
            posts: [],
            rootDirectory: rootDirectory,
            buildDirectory: rootDirectory,
            environment: environment
        )

        let (_, buildContext) = try await BuildContext.withNewContext {
            try await RenderingContext.$current.withValue(renderingContext) {
                try await prepare()
            }
        }

        return .init(
            site: self,
            posts: [],
            rootDirectory: rootDirectory,
            buildContext: buildContext
        )
    }
}
