//
//  AuthenticationView.swift
//  Strut
//
//  Created by Tony Oh on 7/21/24.
//

import SwiftUI
import AuthenticationServices
import Firebase
import CryptoKit

struct AuthenticationView: View {
    var body: some View {
        NavigationStack {
            LoginView()
        }
    }
}

#Preview {
    AuthenticationView()
}
