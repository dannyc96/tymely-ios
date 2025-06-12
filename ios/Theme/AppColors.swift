import SwiftUI

extension Color {
    // These colors are based on the dark mode design from the screenshot.
    static let appBackground = Color.black
    static let componentBackground = Color(white: 0.12) // A dark grey
    static let primaryText = Color.white
    static let secondaryText = Color(white: 0.6)
    static let accent = Color(red: 0.5, green: 0.45, blue: 1.0) // A nice purple
    static let progressGradientStart = Color(red: 0.5, green: 0.3, blue: 1.0)
    static let progressGradientEnd = Color(red: 0.8, green: 0.4, blue: 1.0)
}

// NOTE: The previous Color extension using named colors from the asset catalog
// has been replaced to directly reflect the dark mode design for now.

// Example usage in a real project would involve adding these colors to your Asset Catalog.
// For now, these default values will work for previews. 