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

    @State private var emailApproved: Bool = false

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
                                Task {
                                    if !self.emailApproved {
                                        withAnimation {
                                            self.emailApproved.toggle()
                                        }
                                    }
                                }
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
                    if self.emailApproved {
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
                        .animation(.easeInOut(duration: 0), value: self.emailApproved)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 6)
                    }

                    // Continue / sign in button
                    Button(
                        action: {
                            if !self.emailApproved {
                                withAnimation {
                                    self.focus = .password
                                    self.emailApproved.toggle()
                                }
                            } else {
                                Task {
                                    self.focus = .none
                                    print("starting sign in?????")
                                    if await viewModel.signInWithEmailPassword() {
                                        print("should've successfully signed in?????")
                                    }
                                    print("attempted sign in?????")
                                }
                            }
                        },
                        label: {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.blue5)
                                .animation(.linear(duration: 0.2), value: self.emailApproved)
                                .frame(width: 200, height: 40)
                                .overlay {
                                    Group {
                                        if !self.emailApproved {
                                            Text("continue")
                                        } else {
                                            Text("sign in")

                                        }
                                    }
                                    .animation(.easeInOut(duration: 0.1), value: self.emailApproved)
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                }
                        }
                    )
                    .padding(.top, 8)

                    // OR divider
                    OrDivider()

                    // Sign in with Apple button
                    if !self.emailApproved {
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
                    }

                    // Underlined text: create new account / other sign in options
                    Group {
                        if !self.emailApproved {
                            NavigationLink(
                                destination: SignUpAccountView()
                                    .environment(viewModel)
                            ) {
                                Text("create new account")
                                    .underline()
                            }
                        } else {
                            Button(
                                action: {
                                    withAnimation(.easeOut(duration: 0.1)) {
                                        self.emailApproved.toggle()
                                        viewModel.signInPassword = ""
                                    }
                                },
                                label: {
                                    Text("other sign in options")
                                        .underline()
                                }
                            )
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
