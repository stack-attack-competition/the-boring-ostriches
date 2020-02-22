//
//  ProfileView.swift
//  the-boring-ostriches-client
//
//  Created by Robert Boros on 2020. 02. 22..
//  Copyright © 2020. Robert Boros. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    @State var editing: Bool = false
    @Binding var content: String
    var body: some View {
        VStack{
            ProfileInput(title: "First Name", disabled: !self.editing, value: self.$firstName)
            ProfileInput(title: "Last Name", disabled: !self.editing, value: self.$lastName)
            ProfileInput(title: "Email", disabled: !self.editing, value: self.$email) // TOOD validate email format
            if !editing {
                Button(action: {
                    self.editing.toggle()
                }) {
                    Text("Edit")
                }
            }
            if editing {
                HStack{
                    Button("Save") {
                        guard let req = Config.getRequest(path: "/users/\(Config.session?.id ?? "")", method: "PATCH") else { return }
                        let json = [
                            "email": self.email,
                            "firstName": self.firstName,
                            "lastName": self.lastName,
                            "password": Config.session?.password,
                            "pictureUrl": Config.session?.pictureUrl
                        ]
                        if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []) {
                            URLSession.shared.uploadTask(with: req, from: jsonData) { data, resp, err in
                                if let httpResp = resp as? HTTPURLResponse {
                                    if httpResp.statusCode == 200 {
                                        let decoder = JSONDecoder()
                                        if let json = try? decoder.decode(User.self, from: data!) {
                                            Config.session = json
                                            self.firstName = Config.session!.firstName
                                            self.lastName = Config.session!.lastName
                                            self.email = Config.session!.email
                                            self.content = ""
                                        }
                                    }
                                }
                            }.resume()
                        }
                    }
                    Button(action: {
                        self.editing.toggle()
                    }) {
                        Text("Close")
                    }
                }
            }
        }.onAppear(perform: loadData)
    }
    func loadData() {
        guard let req = Config.getRequest(path: "/users/\(Config.session?.id ?? "")", method: "GET") else { return }
        URLSession.shared.dataTask(with: req) { data, resp, err in
            if let httpResp = resp as? HTTPURLResponse {
                if httpResp.statusCode == 200 {
                    let decoder = JSONDecoder()
                    if let json = try? decoder.decode(User.self, from: data!) {
                        Config.session = json
                        self.firstName = Config.session!.firstName
                        self.lastName = Config.session!.lastName
                        self.email = Config.session!.email
                    }
                }
            }
        }.resume()
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileViewWrapper()
    }
    
    struct ProfileViewWrapper: View {
        @State var content: String = "profile"
        var body: some View {
            ProfileView(content: self.$content)
        }
    }
}


struct ProfileInput: View {
    var title: String
    var disabled: Bool
    @Binding var value: String
    var body: some View {
        VStack (alignment: .leading) {
            Text(title)
                .font(.footnote)
            TextField(title, text: $value).disabled(disabled)
        }.padding()
    }
}
