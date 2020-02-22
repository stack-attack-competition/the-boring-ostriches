//
//  MainView.swift
//  the-boring-ostriches-client
//
//  Created by Robert Boros on 2020. 02. 22..
//  Copyright © 2020. Robert Boros. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @Binding var showMenu: Bool
    @State(initialValue: "") var content: String
    
    var body: some View {
        
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < -100 {
                    withAnimation {
                        self.showMenu = false
                    }
                }
        }
        
        return NavigationView {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    MainContentView(showMenu: self.$showMenu, content: self.$content)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .offset(x: self.showMenu ? geometry.size.width/2 : 0)
                        .disabled(self.showMenu ? true : false)
                    if self.showMenu {
                        MenuView(showMenu: self.$showMenu, content: self.$content)
                            .frame(width: geometry.size.width/2)
                            .transition(.move(edge: .leading))
                    }
                }.gesture(drag)
            }.navigationBarTitle("", displayMode: .inline)
                .navigationBarItems(leading: (
                    Button(action: {
                        withAnimation {
                            self.showMenu.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .imageScale(.large)
                    }
                ))
        }
    }
}

struct MainContentView: View {
    @Binding var showMenu: Bool
    @Binding var content: String
    
    var body: some View {
        VStack {
            if content == "profile" {
                ProfileView(content: self.$content)
            } else if content == "challanges" {
                ChallangeView(content: self.$content)
            } else {
                Text("Hello my friends")
                .bold()
                    .font(.title)
                .fontWeight(.heavy)
                .padding()
                Text("This is my first iOS tutorial!")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
            }
        }
    }
}

struct MenuView: View {
    @Binding var showMenu: Bool
    @Binding var content: String
    
    var body: some View {
        VStack(alignment:.leading) {
            MenuRow(icon: "person", name: "Profile")
                .padding(.top, 100)
                .onTapGesture {
                    self.showMenu = false
                    self.content = "profile"
                }
            MenuRow(icon: "icloud", name: "Challanges")
                .padding(.top, 30)
                .onTapGesture {
                    self.showMenu = false
                    self.content = "challanges"
                }
            Spacer()
        }.padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(red: 32/255, green: 32/255, blue: 32/255))
            .edgesIgnoringSafeArea(.all)
    }
}

#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainViewWrapper()
    }
    
    struct MainViewWrapper: View {
        @State var showMenu: Bool = false
        var body: some View {
            MainView(showMenu: self.$showMenu)
        }
    }
}
#endif

struct MenuRow: View {
    var icon: String
    var name: String
    var body: some View {
        HStack {
            Image(systemName: self.icon)
                .foregroundColor(.gray)
                .imageScale(.large)
            Text(self.name)
        }
    }
}
