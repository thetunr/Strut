//
//  LoginView.swift
//  Strut
//
//  Created by Tony Oh on 7/20/24.
//

import SwiftUI
import AuthenticationServices
import Firebase
import CryptoKit

struct LoginView: View {
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    @State private var errorMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var isLoading: Bool = false
    @State fileprivate var currentNonce: String?
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader {
                let size = $0.size
                
                Image(.minimalBG)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
            }
            .mask {
                Rectangle()
                    .fill(.linearGradient( // TODO: improve later
                        colors: [
                            .white,
                            .white,
                            .white,
                            .white,
                            .white,
                            .white.opacity(0.9),
                            .white.opacity(0.6),
                            .white.opacity(0.2),
                            .clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ))
            }
            
            VStack(alignment: .leading) {
                HStack {
                    VStack {
                        Divider()
                    }
                    Text("or")
                    VStack {
                        Divider()
                    }
                }
                
                SignInWithAppleButton(.signIn) { request in
                    viewModel.handleSignInWithAppleRequest(request)
                } onCompletion: { result in
                    viewModel.handleSignInWithAppleCompletion(result)
                }
                .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
                .frame(maxWidth: .infinity)
                .frame(height: 45)
                .cornerRadius(8)
                
                // TODO: make register page
                NavigationLink(destination: SignUpView()) {
                    Text("Other Sign in Options")
                        .foregroundColor(Color.primary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .contentShape(.capsule)
                        .background {
                            Capsule()
                                .stroke(Color.primary.opacity(0.3), lineWidth: 0.5)
                        }
                }
            }
            .padding(20)
        }
        .alert(errorMessage, isPresented: $showAlert) { }
    }
    
    func showError(_ message: String) {
        errorMessage = message
        showAlert.toggle()
    }
    
    
}

//#Preview {
//    LoginView()
//}


//                SignInWithAppleButton(.signIn) { request in
//                    let nonce = randomNonceString()
//                    currentNonce = nonce
//                    let appleIDProvider = ASAuthorizationAppleIDProvider()
//                    let request = appleIDProvider.createRequest()
//                    request.requestedScopes = [.fullName, .email]
//                    request.nonce = sha256(nonce)
//                } onCompletion: { result in
//                    switch result {
//                    case .success(let authorization):
//                        loginWithFirebase(authorization)
//                    case .failure(let error):
//                        showError(error.localizedDescription)
//                    }
//                }
//                .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
//                .frame(height: 45)
//                .clipShape(.capsule)
//                .padding(.vertical, 10)
