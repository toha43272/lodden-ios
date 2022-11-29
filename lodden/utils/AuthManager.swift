//
//  AuthManager.swift
//  lodden
//
//  Created by Torstein Halvorsen on 29/11/2022.
//

import Foundation
import Amplify
import AWSCognitoAuthPlugin
import UIKit

class AuthManger: ObservableObject {
    
    @Published var isSignedIn: Bool = false
    
    func getCurrentSession() async{
        let session = try? await Amplify.Auth.fetchAuthSession()
        print ("User session: \(String(describing: session))")
        DispatchQueue.main.async {
            self.isSignedIn = ((session?.isSignedIn) != nil)
        }
    }
    
    func signOutGlobally() async {
        let result = await Amplify.Auth.signOut(options: .init(globalSignOut: true))
        guard let signOutResult = result as? AWSCognitoSignOutResult
        else {
            print("Signout failed")
            return
        }

        print("Local signout successful: \(signOutResult.signedOutLocally)")
        switch signOutResult {
        case .complete:
            print ("Signed out globally.")
        case .failed(let error):
            print ("Signed out globally failed: \(error)")
        case let .partial(revokeTokenError, globalSignOutError, hostedUIError):
            print ("Signed out globally failed: \(String(describing: globalSignOutError))")
        }
    }
    
    func getWindow() async -> AuthUIPresentationAnchor {
        #if os(macOS)
        return await MainActor.run {
            let window = NSApplication.shared.windows.first!
            return window
        }
        #elseif canImport(UIKit)
        let scene = await UIApplication.shared.connectedScenes.first!
        let windowSceneDelegate = await scene.delegate as! UIWindowSceneDelegate
        let window = await windowSceneDelegate.window!!
        return window
        #endif
    }
    
    func webSignIn() async {
        do {
            _ = try await Amplify.Auth.signInWithWebUI(
                presentationAnchor: getWindow()
            )
            await getCurrentSession()
        } catch {
            print(error)
        }
    }
    
    func observeAuthEvents() {
        _ = Amplify.Hub.listen(to: .auth) { [weak self] result in
            switch result.eventName {
            case HubPayload.EventName.Auth.signedIn:
                DispatchQueue.main.async {
                    self?.isSignedIn = true
                }
                
            case HubPayload.EventName.Auth.signedOut,
                 HubPayload.EventName.Auth.sessionExpired:
                DispatchQueue.main.async {
                    self?.isSignedIn = false
                }
                
            default:
                break
            }
        }
    }
}

