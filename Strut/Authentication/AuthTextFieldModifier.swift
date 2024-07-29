//
//  AuthTextFieldModifier.swift
//  Strut
//
//  Created by Tony Oh on 7/29/24.
//

import Foundation
import SwiftUI

struct AuthTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 0))
            .frame(height: 45)
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(14)
    }
}

extension View {
    func authTextField() -> some View {
        modifier(AuthTextFieldModifier())
    }
}
