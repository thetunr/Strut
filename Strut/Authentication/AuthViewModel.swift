//
//  AuthViewModel.swift
//  Strut
//
//  Created by Tony Oh on 7/21/24.
//

import AuthenticationServices
import CryptoKit
import Firebase
import FirebaseAuth
import SwiftUI

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

enum AuthenticationFlow {
    case login
    case signUp
}

@Observable
@MainActor
class AuthViewModel {
    @ObservationIgnored @Environment(\.modelContext) private var modelContext  // TODO: test later

    var loginEmail = ""
    var loginPassword = ""

    var signUpUsername = ""
    var signUpEmail = ""
    var signUpPassword = ""
    var signUpConfirmPassword = ""

    var signUpFirstName = ""
    var signUpLastName = ""

    var authenticationState: AuthenticationState = .unauthenticated
    var user: User?

    var flow: AuthenticationFlow = .login
    var isValid = false
    var errorMessage = ""
    var displayName = ""

    init() {
        registerAuthStateHandler()

        //        $flow
        //            .combineLatest($email, $password, $confirmPassword)
        //            .map { flow, email, password, confirmPassword in
        //                flow == .login
        //                    ? !(email.isEmpty || password.isEmpty)
        //                    : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
        //            }
        //            .assign(to: &$isValid)
    }

    private var authStateHandler: AuthStateDidChangeListenerHandle?

    func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
                self.user = user
                self.authenticationState = user == nil ? .unauthenticated : .authenticated
                self.displayName = user?.email ?? ""
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }

    private var currentNonce: String?

    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }

        let charset: [Character] = Array(
            "0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }

        return String(nonce)
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()

        return hashString
    }
}

// Apple sign in
extension AuthViewModel {
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
    }

    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            self.authenticationState = .authenticating
            loginAppleWithFirebase(authorization)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }

    func loginAppleWithFirebase(_ authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                // fatalError("Invalid state: A login callback was received, but no login request was sent.")
                print(
                    "Invalid state: A login callback was received, but no login request was sent.")
                return
            }

            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print(
                    "Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential, including the user's full name.
            let credential = OAuthProvider.appleCredential(
                withIDToken: idTokenString,
                rawNonce: nonce,
                fullName: appleIDCredential.fullName)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error.localizedDescription)
                    return
                }
                // User is signed in to Firebase with Apple.
                self.authenticationState = .authenticated
                print("Authenticated")
            }
        }
    }

    // New functions for Apple sign in extension

}

// Email and password sign in
extension AuthViewModel {
    // Functions for email and password sign in extension

}
