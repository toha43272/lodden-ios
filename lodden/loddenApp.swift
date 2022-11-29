//
//  loddenApp.swift
//  lodden
//
//  Created by Torstein Halvorsen on 29/11/2022.
//

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin

@main
struct loddenApp: App {
    
    @ObservedObject var auth = AuthManger()
    
    init() {
        do {
            Amplify.Logging.logLevel = .verbose
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
        } catch {
            print("An error occurred setting up Amplify: \(error)")
        }
    }

    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .environmentObject(auth)
        }
    }
}
