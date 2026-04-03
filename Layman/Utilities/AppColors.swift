import SwiftUI

struct AppColors {

    // MARK: Background Color

    static let background = Color(
        light: Color(red: 0.98, green: 0.95, blue: 0.90),
        dark: Color(red: 0.10, green: 0.10, blue: 0.12)
    )

    // MARK: Card Color

    static let card = Color(
        light: Color(red: 0.95, green: 0.90, blue: 0.82),
        dark: Color(red: 0.18, green: 0.18, blue: 0.20)
    )

    // MARK: Accent Color

    static let accent = Color(
        light: Color(red: 0.86, green: 0.43, blue: 0.22),
        dark: Color(red: 1.00, green: 0.55, blue: 0.30)
    )
}

//////////////////////////////////////////////////////////////
// MARK: Adaptive Color Extension
//////////////////////////////////////////////////////////////

extension Color {

    init(light: Color, dark: Color) {

        self.init(
            UIColor { trait in

                trait.userInterfaceStyle == .dark
                ? UIColor(dark)
                : UIColor(light)
            }
        )
    }
}
