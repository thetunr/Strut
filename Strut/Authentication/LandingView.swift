//
//  LandingView.swift
//  Strut
//
//  Created by Tony Oh on 7/25/24.
//

import Firebase
import SwiftData
import SwiftUI

@MainActor
struct LandingView: View {
    @State private var launching = true
    @State private var viewModel = AuthViewModel()

    var body: some View {
        if launching {
            LaunchView()
                .onAppear {
                    // TODO: temporary 1.5 second delay for LaunchView
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        launching = false
                    }
                }
        } else {
            VStack {
                switch viewModel.authenticationState {
                case .unauthenticated:
                    LoginView()
                        .environment(viewModel)
                        .transition(.slide)
                        .onAppear {
                            UITextField.appearance().clearButtonMode = .whileEditing
                        }
                case .authenticating:
                    LaunchView()
                        .transition(.blurReplace())
                case .authenticated:
                    HomeView()
                        .environment(viewModel)
                        .transition(.slide)
                }
            }
            .animation(.default, value: viewModel.authenticationState)
        }
    }
}

#Preview {
    LandingView()
}
