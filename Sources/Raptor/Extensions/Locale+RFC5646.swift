//
// Locale+RFC5646.swift
// Raptor
// https://raptor.build
// See LICENSE for license information.
//

import Foundation

package extension Locale {
    /// Returns the RFC 5646–compliant language tag (e.g. `"en-US"` or `"fr"`).
    var asRFC5646: String {
        if let languageCode = language.languageCode?.identifier {
            if let regionCode = region?.identifier {
                return "\(languageCode)-\(regionCode)"
            }
            return languageCode
        }
        return identifier.replacingOccurrences(of: "_", with: "-")
    }

    /// Returns `true` when this locale's script is written right-to-left.
    var isRTL: Bool {
        let code = (language.languageCode?.identifier ?? identifier).lowercased()
        return ["ar", "he", "fa", "ur", "ps", "ku", "dv", "yi", "syc", "arc", "nqo"].contains(code)
    }
}
