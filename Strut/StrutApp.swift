//
//  StrutApp.swift
//  Strut
//
//  Created by Tony Oh on 7/8/24.
//

import SwiftUI
import SwiftData
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct StrutApp: App {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @StateObject private var viewModel = AuthenticationViewModel()

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            VStack {
                if (!isLoggedIn) {
                    AuthenticationView()
                        .environmentObject(viewModel)
                        .border(.blue, width: 2)
                        .transition(.slide)
                } else {
                    HomeView()
                        .environmentObject(viewModel)
                        .border(.red, width: 2)
                        .transition(.slide)
                }
            }
            .animation(.default, value: isLoggedIn)
        }
        .modelContainer(sharedModelContainer)
    }
}
