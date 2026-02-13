//
//  AspectRatio.swift
//  Raptor
//  https://raptor.build
//  See LICENSE for license information.
//

import Testing

@testable import Raptor

/// Tests for the `AspectRatio` modifier.
@Suite("AspectRatio Tests")
struct AspectRatioTests {
    @Test("Verify AspectRatio Modifiers", arguments: AspectRatio.allCases)
    func verifyAspectRatioModifiers(ratio: AspectRatio) {
        let element = Text("Hello").aspectRatio(ratio)
        let output = element.markupString()
        let ratioString = String(format: "%.4g", ratio.numericValue)
        #expect(output == "<p style=\"aspect-ratio: \(ratioString)\">Hello</p>")
    }

    @Test("Verify Content Modes", arguments: AspectRatio.allCases, ContentMode.allCases)
    func verifyContentModes(ratio: AspectRatio, mode: ContentMode) {
        let element = Image("/images/example.jpg").aspectRatio(ratio, contentMode: mode)
        let output = withTestRenderingEnvironment {
            element.markupString()
        }
        let ratioString = String(format: "%.4g", ratio.numericValue)

        #expect(output == """
        <div style="aspect-ratio: \(ratioString)">\
        <img src="/images/example.jpg" alt="" class="\(mode.cssClass)" /></div>
        """)
    }
}
