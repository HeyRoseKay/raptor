<p align="center">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://github.com/user-attachments/assets/c7f37277-5a47-405b-b4f4-6be7b0625a61">
  <source media="(prefers-color-scheme: light)" srcset="https://github.com/user-attachments/assets/cd47c0ab-b675-42ad-a45f-309e730a3d17">
  <img alt="Shows a black logo in light color mode and a white one in dark color mode." src="https://user-images.githubusercontent.com/25423296/163456779-a8556205-d0a5-45e2-ac17-42d089e3c3f8.png">
</picture>
</p>

<h2 align="center">a Swift framework for static sites and server-side rendering</h2>

<p align="center">
   <img src="https://img.shields.io/badge/macOS-15.6+-2980b9.svg" />
   <img src="https://img.shields.io/badge/swift-6.2+-8e44ad.svg" />
</p>

---

## What Is Raptor?

Raptor is a Swift-first static site generator designed for developers who want the safety, structure, and expressiveness of Swift—without writing HTML or CSS.

Raptor provides a purpose-built API for generating websites at compile time. Its syntax will feel familiar if you’ve used SwiftUI, but it is not a SwiftUI-to-HTML converter. Instead, Raptor embraces the constraints of the web and models them explicitly in Swift.

The result: fast builds, predictable output, and websites whose structure is validated by the compiler.

---

## Design Philosophy

Raptor is built around a few core principles:

### 1. Swift, Not Templates
Websites are authored entirely in Swift. Pages, layouts, and themes are expressed as types, not text files or templates.

### 2. Compile-Time Structure
Invalid layouts, missing content, and incompatible configurations are caught during compilation—not at runtime or in the browser.

### 3. Separation by Default
Content, structure, and presentation are distinct layers:
- **Content** lives in Markdown
- **Structure** lives in Swift
- **Presentation** lives in themes and styles

This keeps large sites maintainable as they grow.

### 4. Web-Specific APIs
Raptor borrows ideas from SwiftUI where they make sense, but its APIs are designed specifically for static site generation—not UI rendering.

---

## Core Capabilities

- **Declarative page composition** using Swift
- **Markdown posts** with YAML front matter
- **Layout and theme systems** with light/dark support
- **Localization** with locale-specific content
- **Syntax highlighting** with configurable themes
- **Post widgets** defined in Swift and embedded in Markdown
- **Built-in site search**
- **Optional Vapor integration** for server-side rendering
- **Self-contained output** (no Bootstrap or external CSS frameworks)
- **Strong type safety** across layouts and content

For a full breakdown of features and APIs, see the documentation at  
👉 **https://raptor.build**

---

## What Raptor Code Looks Like

Pages and components are written using a declarative Swift syntax:

```swift
Text("SwiftUI for the web")
   .font(.title1)

Text(markdown: "Supports *inline* Markdown")
   .foregroundStyle(.secondary)

Link("Learn Swift", destination: "https://www.swift.org")
   .linkStyle(.button)

Image("hero.jpg", description: "Site hero image")
   .frame(maxHeight: 400)
```

Layouts define structure independently of content:

```swift
struct MyLayout: Layout {
   var body: some Document {
       Navigation {
           InlineText("RAPTOR")
               .navigationItemRole(.logo)
       }

       Main {
           content
           SubscribeForm()
       }
   }
}
```

Interactive behavior is modeled declaratively:

```swift
Disclosure("Advanced Settings") {
   Text("Configuration options here")
}

Button("Subscribe", action: .showModal("newsletter"))
   .buttonStyle(.primary)
```

---

## Content with Markdown

Markdown files are used for long-form content and posts, with YAML front matter for metadata:

```yaml
---
title: Welcome to Raptor
date: 2026-01-07
tags: swift, web, static-sites
---

Your Markdown content here, with support for code blocks,
images, and custom Swift-defined widgets.
```

---

## Project Structure

A Raptor site follows a simple, conventional layout:

```
MySite/
├── Assets/          # Images, fonts, static files
├── Posts/           # Markdown content
├── Sources/         # Swift code (pages, layouts, themes)
│   └── Resources/   # Localized strings (optional)
└── Build/           # Generated output
```

For multilingual sites, organize posts by locale:

```
Posts/
├── en-us/
│   └── welcome.md
└── it/
   └── welcome.md
```

This structure is created automatically when you generate a new site.

---

## Getting Started

Install the Raptor command-line tool:

```bash
git clone https://github.com/raptor-build/raptor
cd raptor
make
make install
```

Create a new site:

```bash
raptor new MySite
cd MySite
open Package.swift
```

Build and preview your site:

```bash
raptor build
raptor run --preview
```

The preview server is designed for an Xcode workflow—build with <kbd>Cmd+R</kbd>, then refresh your browser to see changes instantly.

Detailed guides and workflows are available at  
👉 **https://raptor.build/getting-started**

---

## Contributing

Contributions are welcome and appreciated.

- **Small improvements** (tests, documentation, comments, minor fixes) can be submitted directly.
- **Larger changes** (features, refactors, behavioral changes) should begin with an issue to discuss approach and scope.

Please spend time using Raptor before attempting significant contributions—understanding its design goals will lead to better results for everyone.

---

## Project Status

Raptor is currently in **early beta**.

The core architecture is stable, but some APIs may evolve as the project matures. During this period, we recommend pinning dependency versions when using Raptor in production.

---

## License

Copyright (c) 2026 Raptor contributors. Raptor is licensed under MIT. See the [LICENSE](LICENSE) file for full details.

---

## Acknowledgments

This project builds on ideas and prior work from the Ignite project, which influenced its early development. Some portions of the implementation were adapted from that work and have since evolved. Portions derived from Ignite are licensed under the MIT License. See `LICENSES/IGNITE_LICENSE` for details.
