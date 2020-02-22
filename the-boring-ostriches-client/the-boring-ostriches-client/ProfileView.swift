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
                    Button(action: {
                        print("save...")
                    }) {
                        Text("Save")
                    }
                    Button(action: {
                        self.editing.toggle()
                    }) {
                        Text("Close")
                    }
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
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
