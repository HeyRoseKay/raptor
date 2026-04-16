//
// Site+Publishing.swift
// Raptor
// https://raptor.build
// See LICENSE for license information.
//

package extension Site {
    /// Prepares the site for rendering by loading content, resolving environments,
    /// and executing site-level preparation.
    ///
    /// This method performs all shared setup required by both publishing and
    /// development servers, including content loading, environment construction,
    /// localization registration, and build context resolution.
    ///
    /// - Parameters:
    ///   - file: The source file that initiated the build. Used to locate the site root.
    ///   - buildDirectoryPath: The relative path where build artifacts should be written.
    /// - Returns: A fully prepared build state ready for rendering or publishing.
    mutating func preparePublishingContext(
        from file: StaticString = #filePath,
        buildDirectoryPath: String = "Build"
    ) async throws -> PublishingContext {
        let packageDirectory = try URL.packageDirectory(from: file)
        let rootDirectory = packageDirectory
        let buildDirectory = packageDirectory.appending(path: buildDirectoryPath)

        let contentLoader = ContentLoader(
            processor: postProcessor,
            locales: locales,
            widgets: postWidgets)

        var environment = EnvironmentValues(
            rootDirectory: rootDirectory,
            site: self.context,
            allContent: [])

        var renderingContext = RenderingContext(
            site: context,
            posts: [],
            rootDirectory: rootDirectory,
            buildDirectory: buildDirectory,
            environment: environment)

        let (allContent, postContext) = try BuildContext.withNewContext {
            try RenderingContext.$current.withValue(renderingContext) {
                try contentLoader.load(from: rootDirectory)
            }
        }

        environment.posts = PostCollection(content: allContent)
        renderingContext.posts = allContent
        renderingContext.environment = environment

        if isMultilingual {
            Localizer.autoRegister(from: file)
        }

        var (_, buildContext) = try await BuildContext.withNewContext {
            try await RenderingContext.$current.withValue(renderingContext) {
                try await prepare()
            }
        }

        buildContext = buildContext.merging(postContext)
        buildContext.syntaxHighlighterLanguages = OrderedSet(allContent.flatMap(\.syntaxHighlighters))

        return PublishingContext(
            content: allContent,
            buildContext: buildContext,
            rootDirectory: rootDirectory,
            buildDirectory: buildDirectory)
    }

    /// A resolved, immutable snapshot of this site's configuration used during rendering and publishing.
    var context: SiteContext {
        SiteContext(
            name: self.name,
            titleSuffix: self.titleSuffix,
            description: self.description,
            url: self.url,
            feedConfiguration: self.feedConfiguration,
            locales: self.locales,
            version: self.version,
            themes: self.themes,
            author: self.author,
            favicon: self.favicon,
            isSearchEnabled: self.isSearchEnabled,
            isMultilingual: self.isMultilingual,
            syntaxHighlighterConfiguration: self.syntaxHighlighterConfiguration,
            colorScheme: self.colorScheme,
            highlighterThemes: Array(self.allSyntaxHighlighterThemes),
            robotsConfiguration: self.robotsConfiguration,
            prettifyHTML: self.prettifyHTML,
            postProcessor: self.postProcessor
        )
    }

    /// Whether the site has enabled search.
    var isSearchEnabled: Bool {
        !(searchPage is EmptySearchPage)
    }

    /// Whether the site supports multiple languages.
    var isMultilingual: Bool {
        locales.count > 1
    }

    /// Returns the site's global layout when `DefaultLayout` is requested,
    /// otherwise returns the provided layout unchanged.
    /// - Parameter page: The page that uses the layout.
    /// - Returns: The resolved layout for the page.
    func layout(for page: some PageRepresentable) -> any Layout {
        page.usesDefaultLayout ? layout : page.layout
    }

    /// Locates the best layout to use for a piece of Markdown content. Layouts
    /// are specified using YAML front matter, but if none are found then the first
    /// layout in your site's `layouts` property is used.
    /// - Parameter content: The content that is being rendered.
    /// - Returns: The correct `PostPage` instance to use for this post.
    func postPage(for post: Post) -> any PostPage {
        if let name = post.layout {
            if let match = postPages.first(where: {
                String(describing: type(of: $0)) == name
            }) {
                return match
            }
            fatalError(BuildError.missingNamedLayout(name).description)
        }
        return postPages.first ?? {
            fatalError(BuildError.missingDefaultLayout.description)
        }()
    }
}

extension Site {
    /// Whether the site uses more than one theme.
    var hasMultipleThemes: Bool {
        themes.count > 1
    }

    /// The default locale of the site.
    var defaultLocale: Locale? {
        locales.first
    }

    /// The syntax highlighting themes from every site theme.
    var allSyntaxHighlighterThemes: [any SyntaxHighlighterTheme] {
        let all = themes.flatMap {
            ResolvedTheme($0).syntaxHighlighterThemes
        }

        let deduped = all.reduce(into: [String: any SyntaxHighlighterTheme]()) {
            $0[$1.id] = $1
        }

        return deduped.values.sorted { $0.id < $1.id }
    }
}
