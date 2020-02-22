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
    @State(initialValue: "login") var content: String
    
    var body: some View {
        VStack {
            if !userAuth.isLoggedin {
                if content == "login" {
                    LoginPageView(content: self.$content)
                } else if content == "signup" {
                    SignupPageView(content: self.$content)
                } else if content == "forgot" {
                    ForgetPageView(content: self.$content)
                }
            } else {
                MainView(showMenu: self.$showMenu)
            }
        }
    }
}

struct LoginPageView: View {
    @Binding var content: String
    
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var authService: AuthService
    
    @State(initialValue: "") private var username: String
    @State(initialValue: "") private var password: String
    @State(initialValue: false) private var showMsg: Bool
    @State(initialValue: "") var toastMsg: String
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Email", text: $username)
                    .autocapitalization(.none)
                    .padding()
                SecureField("Password", text: $password)
                    .padding()
                
                Button("Login") {
                    self.login()
                }.padding()
                Button("Forgot Password") {
                    self.content = "forgot"
                }.padding(.top, 20)
                    .font(.subheadline)
                    .opacity(0.5)
            }
            .navigationBarItems(trailing: Button("Sign Up") {
                self.content = "signup"
            })
                .padding()
                .toast(isShowing: $showMsg, text: Text(toastMsg))
        }
    }
    
    func login() {
        let json = [
            "email": self.username,
            "password": self.password
        ]
        guard let req = Config.getRequest(path: "/auth/login", method: "POST") else { return }
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []) {
            URLSession.shared.uploadTask(with: req, from: jsonData) { data, resp, err in
                if let httpResp = resp as? HTTPURLResponse {
                    if httpResp.statusCode == 201 {
                        let decoder = JSONDecoder()
                        if let json = try? decoder.decode(User.self, from: data!) {
                            Config.session = json
                            self.userAuth.username = self.username
                            self.userAuth.isLoggedin = true
                        }
                    } else {
                        self.toastMsg = "Invalid credentials"
                        self.showMsg = true
                    }
                }
            }.resume()
        }
    }
}

struct SignupPageView: View {
    @Binding var content: String
    
    @State(initialValue: "") var email: String;
    @State(initialValue: "") var firstName: String;
    @State(initialValue: "") var lastName: String;
    @State(initialValue: "") var pictureUrl: String;
    @State(initialValue: "") var password: String;
    @State(initialValue: "") var confirmPwd: String;
    
    @State(initialValue: false) private var showMsg: Bool
    @State(initialValue: "") var toastMsg: String
    var body: some View {
        NavigationView {
            VStack {
                TextField("Email", text: self.$email)
                    .autocapitalization(.none)
                    .padding()
                TextField("First name", text: self.$firstName)
                    .padding()
                TextField("Last name", text: self.$lastName)
                    .padding()
                TextField("Picture URL", text: self.$pictureUrl)
                    .autocapitalization(.none)
                    .padding()
                TextField("Password", text: self.$password)
                    .disableAutocorrection(true)
                    .padding()
                TextField("Confirm password", text: self.$confirmPwd)
                    .disableAutocorrection(true)
                    .padding()
                Button("Register") {
                    if self.password != self.confirmPwd {
                        self.toastMsg = "Invalid confirm password"
                        self.showMsg = true
                        return
                    }
                    
                    guard let req = Config.getRequest(path: "/auth/register", method: "POST") else { return }
                    let json = [
                        "email": self.email,
                        "password": self.password,
                        "firstName": self.firstName,
                        "lastName": self.lastName,
                        "pictureUrl": self.pictureUrl
                    ]
                    
                    if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []) {
                        URLSession.shared.uploadTask(with: req, from: jsonData) {data,resp,err in
                            if let httpResp = resp as? HTTPURLResponse {
                                if httpResp.statusCode == 201 {
                                    self.content = "login"
                                } else {
                                    self.toastMsg = "Invalid credentials"
                                    self.showMsg = true
                                }
                            }
                        }.resume()
                    }
                }
                Button("Already have an account? Login"){
                    self.content = "login"
                }.font(.footnote).padding(.top, 50)
            }
            .toast(isShowing: $showMsg, text: Text(toastMsg))
        }
    }
}

struct ForgetPageView: View {
    
    @Binding var content: String
    @State(initialValue: "") var email: String;
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Email", text: self.$email)
                    .padding()
                Button("Send") {
                    print("send")
                }
                Button("Back to login"){
                    self.content = "login"
                }.font(.footnote).padding(.top, 50)
            }
        }
    }
}


#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(UserAuth())
    }
}
#endif

