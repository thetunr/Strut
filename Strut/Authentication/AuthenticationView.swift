//
//  AuthenticationView.swift
//  Strut
//
//  Created by Tony Oh on 7/21/24.
//

import AuthenticationServices
import CryptoKit
import Firebase
import SwiftUI
import SwiftUIIntrospect

//import SwiftUIIntrospect

enum SignInFocusedField: Hashable {
    case email, password
}

enum SignInOption {
    case apple
    case google
}

struct AuthenticationView: View {
    @Environment(AuthViewModel.self) var viewModel: AuthViewModel
    @Environment(\.colorScheme) private var colorScheme

    @FocusState var focus: SignInFocusedField?

    var body: some View {
        @Bindable var viewModel = viewModel

        NavigationView {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    Spacer()

                    Image(.doodoo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minHeight: 160)
                        .frame(maxHeight: 180)
                        .padding(.vertical, 20)

                    // Email text field
                    ZStack(alignment: .init(horizontal: .leading, vertical: .top)) {
                        TextField("", text: $viewModel.signInEmail)
                            .onSubmit {
                                self.focus = .password
                            }
                            .focused($focus, equals: .email)
                            .submitLabel(.next)
                            .authTextField()

                        Text("email")
                            .padding(EdgeInsets(top: 2, leading: 10, bottom: 0, trailing: 0))
                            .foregroundColor(Color.grey5)
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 6)

                    // Password secure text field
                    ZStack(alignment: .init(horizontal: .leading, vertical: .top)) {
                        SecureField("", text: $viewModel.signInPassword)
                            .focused($focus, equals: .password)
                            .authTextField()

                        Text("password")
                            .padding(
                                EdgeInsets(top: 2, leading: 10, bottom: 0, trailing: 0)
                            )
                            .foregroundColor(Color.grey5)
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 6)

                    // Continue / sign in button
                    Button(
                        action: {
                            Task {
                                self.focus = .none
                                print("starting sign in?????")
                                if await viewModel.signInWithEmailPassword() {
                                    print("should've successfully signed in?????")
                                }
                                print("attempted sign in?????")
                            }
                        },
                        label: {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.blue5)
                                .frame(width: 200, height: 40)
                                .overlay {
                                    Text("sign in")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                }
                        }
                    )
                    .padding(.top, 8)

                    // OR divider
                    OrDivider()

                    // Sign in with Apple button

                    SignInWithAppleButton(
                        .signIn,
                        onRequest: { request in
                            viewModel.handleSignInWithAppleRequest(request)
                        },
                        onCompletion: { result in
                            viewModel.handleSignInWithAppleCompletion(result)
                        }
                    )
                    .frame(width: 220, height: 40)
                    .cornerRadius(14)
                    .padding(10)
                    .signInWithAppleButtonStyle(.white)
                    //                        .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
                    // TODO: bug when toggling dark mode

                    // Underlined text: create new account / other sign in options
                    Group {
                        NavigationLink(
                            destination: SignUpAccountView()
                                .environment(viewModel)
                        ) {
                            Text("create new account")
                                .underline()
                        }
                    }
                    .foregroundColor(Color.grey5)
                    .font(.system(size: 12))
                    .padding(.bottom, 30)

                    Spacer()
                }
                .padding(30)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background(Color.blue1)
                .frame(alignment: .center)
            }
        }
    }
}

#Preview {
    AuthenticationView()
        .environment(AuthViewModel())
}

struct OrDivider: View {
    var body: some View {
        HStack {
            VStack {
                Divider()
                    .frame(height: 1)
                    .background(Color.white)
            }

            Text("or")
                .font(.system(size: 16))
                .foregroundColor(Color.white)
                .frame(width: 20)

            VStack {
                Divider()
                    .frame(height: 1)
                    .background(Color.white)
            }
        }
        .padding(.top, 10)
        .padding(.bottom, 10)
    }
}
