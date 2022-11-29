//
//  SignInView.swift
//  lodden
//
//  Created by Torstein Halvorsen on 29/11/2022.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var auth: AuthManger
    
    var body: some View {
        
        Button ("Sign in ", action: {
            Task{
                await auth.webSignIn()
                auth.observeAuthEvents()
            }
        })
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
