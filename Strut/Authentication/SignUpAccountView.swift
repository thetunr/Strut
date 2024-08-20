//
//  SignUpAccountView.swift
//  Strut
//
//  Created by Tony Oh on 7/21/24.
//

import SwiftUI

enum SignUpAccountFocusedField: Hashable {
    case username, email, password, confirmPassword
}

struct SignUpAccountView: View {
    @Environment(AuthViewModel.self) var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss

    @FocusState var focus: SignUpAccountFocusedField?

    var body: some View {
        @Bindable var viewModel = viewModel

        NavigationView {
            VStack(spacing: 0) {
                Text("Create an Account")
                    .font(.custom("Inter-Medium", size: 32))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.grey6)
                    .padding(.bottom, 20)

                Divider()
                    .frame(width: 200)
                    .padding(.bottom, 20)

                // Account VStack
                VStack(spacing: 0) {
                    Text("Account")
                        .font(.custom("Inter-Medium", size: 16))
                        .foregroundColor(Color.grey6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 6)

                    ZStack(alignment: .init(horizontal: .leading, vertical: .top)) {
                        TextField("", text: $viewModel.signUpUsername)
                            .focused($focus, equals: .username)
                            .authTextField()
                            .onSubmit {
                                self.focus = .email
                            }

                        Text("username")
                            .padding(EdgeInsets(top: 2, leading: 10, bottom: 0, trailing: 0))
                            .foregroundColor(Color.grey5)
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)

                    ZStack(alignment: .init(horizontal: .leading, vertical: .top)) {
                        TextField("", text: $viewModel.signUpEmail)
                            .focused($focus, equals: .email)
                            .authTextField()
                            .onSubmit {
                                self.focus = .password
                            }

                        Text("email")
                            .padding(EdgeInsets(top: 2, leading: 10, bottom: 0, trailing: 0))
                            .foregroundColor(Color.grey5)
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
                }
                .padding(.bottom, 10)

                // Password VStack
                VStack(spacing: 0) {
                    Text("Password")
                        .font(.custom("Inter-Medium", size: 16))
                        .foregroundColor(Color.grey6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 6)
                        .onSubmit {
                            self.focus = .confirmPassword
                        }

                    ZStack(alignment: .init(horizontal: .leading, vertical: .top)) {
                        SecureField("", text: $viewModel.signUpPassword)
                            .focused($focus, equals: .password)
                            .authTextField()
                            .frame(height: 35)

                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
                }
                .padding(.bottom, 10)

                // Confirm Password VStack
                VStack(spacing: 0) {
                    Text("Confirm Password")
                        .font(.custom("Inter-Medium", size: 16))
                        .foregroundColor(Color.grey6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 6)

                    ZStack(alignment: .init(horizontal: .leading, vertical: .top)) {
                        SecureField("", text: $viewModel.signUpConfirmPassword)
                            .focused($focus, equals: .confirmPassword)
                            .authTextField()
                            .frame(height: 35)
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
                }

                // Back and Next buttons HStack
                HStack {
                    // Back button
                    Button(
                        action: {
                            dismiss()
                        },
                        label: {
                            Text("back")
                                .font(.system(size: 16))
                                .foregroundColor(Color.grey6)
                                .frame(width: 75, height: 32)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.clear)
                                        .stroke(Color.blue5, lineWidth: 1)
                                )
                        }
                    )

                    Spacer()

                    // Next button
                    NavigationLink(
                        destination: SignUpUserView()
                            .environment(viewModel)
                    ) {
                        Text("next")
                            .font(.system(size: 16))
                            .foregroundColor(Color.white)
                            .frame(width: 75, height: 32)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.blue5)
                            )
                    }
                }
                .padding(.horizontal, 10)
                .padding(.top, 10)
            }
            .padding(30)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.blue1)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SignUpAccountView()
}
