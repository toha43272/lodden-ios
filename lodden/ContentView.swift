//
//  ContentView.swift
//  lodden
//
//  Created by Torstein Halvorsen on 29/11/2022.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var auth: AuthManger
    
    var body: some View {
        
        if auth.isSignedIn {
            Text ("Signed in")
            Button ("Sign out", action: {
                Task{
                    await auth.signOutGlobally()
                }
            })
        } else {
            SignInView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
