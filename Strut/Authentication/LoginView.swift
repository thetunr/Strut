//
//  LoginView.swift
//  Strut
//
//  Created by Tony Oh on 7/21/24.
//

import AuthenticationServices
import CryptoKit
import Firebase
import SwiftUI

enum LoginFocusedField: Hashable {
    case email, password
}

enum SignInOption {
    case apple
    case google
}

struct LoginView: View {
    @Environment(AuthViewModel.self) var viewModel: AuthViewModel
    @Environment(\.colorScheme) private var colorScheme

    @FocusState var focus: LoginFocusedField?

    @State private var emailApproved: Bool = false

    var body: some View {
        @Bindable var viewModel = viewModel

        NavigationView {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    Image(.doodoo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 180)
                        .padding(.vertical, 20)
//                        .border(.red, width: 2)
                    //                        .frame(height: geometry.size.height / 2)

                    // TODO: FIX TEXT INPUT, unknown error, bug not my fault i think? can't seem to find out why.
                    ZStack(alignment: .init(horizontal: .leading, vertical: .top)) {
                        TextField("", text: $viewModel.loginEmail)
                            .focused($focus, equals: .email)
                            .submitLabel(.next)
                            .onSubmit {
                                self.focus = .password
                            }
                            .authTextField()

                        Text("email")
                            .padding(EdgeInsets(top: 2, leading: 10, bottom: 0, trailing: 0))
                            .foregroundColor(Color.grey5)
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 6)

                    if emailApproved {
                        ZStack(alignment: .init(horizontal: .leading, vertical: .top)) {
                            SecureField("", text: $viewModel.loginPassword)
                                .focused($focus, equals: .password)
                                .submitLabel(.done)
                                .authTextField()

                            Text("password")
                                .padding(
                                    EdgeInsets(top: 2, leading: 10, bottom: 0, trailing: 0)
                                )
                                .foregroundColor(Color.grey5)
                        }
                        .animation(.easeInOut, value: emailApproved)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 6)
                    }

                    Button(
                        action: {
                            if !emailApproved {
                                withAnimation {
                                    emailApproved.toggle()
                                }
                            } else {

                            }
                        },
                        label: {
                            Group {
                                if !emailApproved {
                                    Text("continue")
                                } else {
                                    Text("sign in")
                                }
                            }
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .frame(width: 200, height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.blue5)
                            )
                        }
                    )
                    .animation(.easeInOut, value: emailApproved)
                    .padding(.top, 8)

                    // OR divider
                    OrDivider()

                    if !emailApproved {
                        // Apple & Google sign in buttons
                        HStack {
                            Spacer()

                            // TODO: MAKE CUSTOM APPLE SIGN IN BUTTON
                            SignInButton(signInOption: .apple)
                                .environment(viewModel)

                            Spacer()

                            SignInButton(signInOption: .google)
                                .environment(viewModel)

                            Spacer()
                        }
                        .padding(.bottom, 10)
                    }

                    // TODO: make sign up page
                    Group {
                        if !emailApproved {
                            NavigationLink(destination: SignUpView()) {
                                Text("create new account")
                                    .underline()
                            }
                        } else {
                            Button(
                                action: {
                                    withAnimation {
                                        emailApproved.toggle()
                                        viewModel.loginPassword = ""
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

                }
                .padding(30)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background(Color.blue1)
                //        .onTapGesture {
                //            UIApplication.shared.sendAction(
                //                #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                //        }
            }
        }
    }
}

#Preview {
    LoginView()
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

struct SignInButton: View {
    @Environment(AuthViewModel.self) var viewModel: AuthViewModel

    let signInOption: SignInOption

    var body: some View {
        HStack {
            if signInOption == .apple {
                Image(systemName: "applelogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 12, height: 12)

                Text("Apple")
                    .font(.callout)
            } else if signInOption == .google {
                Image(.googleIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 12, height: 12)

                Text("Google")
                    .font(.callout)
            }
        }
        .foregroundColor(Color.primary)
        .frame(width: 120, height: 45)
        .background {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(UIColor.systemBackground))
                .frame(width: 120, height: 45)
        }

        .overlay {
            Group {
                if signInOption == .apple {
                    SignInWithAppleButton(
                        .signIn,
                        onRequest: { request in
                            viewModel.handleSignInWithAppleRequest(request)
                        },
                        onCompletion: { result in
                            viewModel.handleSignInWithAppleCompletion(result)
                        }
                    )
                } else if signInOption == .google {

                }
            }
            .frame(width: 120, height: 45)
            .cornerRadius(14)
            .blendMode(.overlay)

        }
        //        .animation(.easeInOut(duration: 0.2), value: isPressed)
        //        .opacity(isPressed ? 0.75 : 1.0)
        //        .scaleEffect(isPressed ? 0.95 : 1.0)

        //                    .gesture(
        //                        DragGesture(minimumDistance: 0)
        //                            .onChanged { _ in
        //                                withAnimation {
        //                                    isPressed = true
        //                                }
        //                            }
        //                            .onEnded { _ in
        //                                withAnimation {
        //                                    isPressed = false
        //                                }
        //                            }
        //                    )

        //        .onLongPressGesture(
        //            minimumDuration: 0.1,
        //            pressing: { pressing in
        //                withAnimation(.easeInOut(duration: 0.1)) {
        //                    isPressed = pressing
        //                }
        //            }, perform: {})
    }
}
