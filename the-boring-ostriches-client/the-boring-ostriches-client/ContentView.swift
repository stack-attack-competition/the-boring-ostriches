//
//  ContentView.swift
//  the-boring-ostriches-client
//
//  Created by Robert Boros on 2020. 02. 22..
//  Copyright © 2020. Robert Boros. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userAuth: UserAuth
    @State(initialValue: false) var showMenu: Bool
    
    var body: some View {
        VStack {
            if !userAuth.isLoggedin {
                LoginView()
            } else {
                MainView(showMenu: self.$showMenu)
            }
        }
    }
}

struct LoginView: View {
    @State(initialValue: "") private var username: String
    @State(initialValue: "") private var password: String
    @State(initialValue: false) private var showMsg: Bool
    
    @EnvironmentObject var userAuth: UserAuth
    
    var body: some View {
        VStack {
            
            TextField("Username", text: $userAuth.username)
                .padding()
            SecureField("Password", text: $password)
                .padding()
            
            Button(action: {
                self.login()
            }) {
                Text("Login")
                    .padding()
            }
        }
        .padding()
        .toast(isShowing: $showMsg, text: Text("Welcome \(userAuth.username)"))
    }
    
    func login() {
        self.showMsg.toggle()
        self.userAuth.isLoggedin.toggle()
    }
}


#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(UserAuth())
    }
}
#endif
