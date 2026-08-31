import SwiftUI

struct LogoModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 225,height: 105)
    }
}

extension View {
    func logoSize() -> some View {
        self.modifier(LogoModifier())
    }
}
