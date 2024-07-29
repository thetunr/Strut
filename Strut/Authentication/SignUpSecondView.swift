//
//  SignUpSecondView.swift
//  Strut
//
//  Created by Tony Oh on 7/28/24.
//

import SwiftUI

enum SignUpSecondFocusedField: Hashable {
    case firstName, lastName, birthday
}

struct SignUpSecondView: View {
    @Environment(\.dismiss) var dismiss

    @FocusState var focus: SignUpSecondFocusedField?
    @State private var firstName: String = ""
    @State private var lastName: String = ""

    var body: some View {
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

                // Name VStack
                VStack(spacing: 0) {
                    Text("Name")
                        .font(.custom("Inter-Medium", size: 16))
                        .foregroundColor(Color.grey6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 6)

                    ZStack(alignment: .init(horizontal: .leading, vertical: .top)) {
                        TextField("", text: $firstName)
                            .focused($focus, equals: .firstName)
                            .authTextField()

                        Text("first")
                            .padding(EdgeInsets(top: 2, leading: 10, bottom: 0, trailing: 0))
                            .foregroundColor(Color.grey5)
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)

                    ZStack(alignment: .init(horizontal: .leading, vertical: .top)) {
                        TextField("", text: $lastName)
                            .focused($focus, equals: .lastName)
                            .authTextField()

                        Text("last")
                            .padding(EdgeInsets(top: 2, leading: 10, bottom: 0, trailing: 0))
                            .foregroundColor(Color.grey5)
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
                }
                .padding(.bottom, 10)

                // Birthday VStack
                VStack(spacing: 0) {
                    Text("Birthday")
                        .font(.custom("Inter-Medium", size: 16))
                        .foregroundColor(Color.grey6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 6)

                    // Birthday component

                }
                .padding(.horizontal, 10)
                .padding(.bottom, 10)

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
                        destination: SignUpSecondView()
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
    SignUpSecondView()
}
