//
//  ChallangeView.swift
//  the-boring-ostriches-client
//
//  Created by Robert Boros on 2020. 02. 22..
//  Copyright © 2020. Robert Boros. All rights reserved.
//

import SwiftUI

struct ChallangeView: View {
    @Binding var content: String
    @State var challanges: [Challange] = []
    @State var navhappen: Bool = false
    var body: some View {
        NavigationView{
            List(self.challanges) { challange in
                ChallangeRow(challange: challange)
            }
            .onAppear(perform: loadData)
            .navigationBarItems(trailing: NavigationLink(destination: NewChallange(navhappen: self.$navhappen), isActive: $navhappen){
                Text("+").foregroundColor(.blue)
            }.font(.largeTitle))
        }
    }
    func loadData() {
        guard let req = Config.getRequest(path: "/users/\(Config.session?.id ?? "")/challenges", method: "GET") else { return }
        URLSession.shared.dataTask(with: req) { data, resp, err in
            if let httpResp = resp as? HTTPURLResponse {
                if httpResp.statusCode == 200 {
                    let decoder = JSONDecoder()
                    if let json = try? decoder.decode([Challange].self, from: data!){
                        self.challanges = json
                    }
                }
            }
        }.resume()
    }
}

struct ChallangeRow: View {
    var challange: Challange
    var body: some View {
        NavigationLink(destination: ChallangeDetails(challange: challange)) {
            HStack{
                Text("\(Config.session!.firstName) \(Config.session!.lastName)")
                    .padding()
                Text(challange.title)
                    .font(.footnote)
                    .padding()
            }
        }
    }
    
}

struct ChallangeDetails: View {
    var challange: Challange
    var body: some View {
        VStack{
            Text(challange.title).font(.title).padding()
            HStack{
                Text((challange.outcome ? "success" : "under process"))
                    .foregroundColor((challange.outcome ? .green : .orange ))
                Text(challange.endDate).font(.body).italic().padding()
            }
            if challange.outcome {
                Button(challange.proofUrl) {
                    guard let url = URL(string: self.challange.proofUrl) else { return }
                    UIApplication.shared.open(url)
                }
            }
            ScrollView {
                Text(challange.description).font(.body)
            }
            .padding()
        }.navigationBarTitle("\(Config.session!.firstName) \(Config.session!.lastName)")
    }
}

struct NewChallange: View {
    @State(initialValue: "") var title: String;
    @State(initialValue: "") var descp: String;
    @State(initialValue: .init()) var end: Date;
//    @State(initialValue: .init()) var endTime: Date;
    @Binding var navhappen: Bool
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }
    var body: some View {
        VStack{
            TextField("Title", text: self.$title).padding()
            TextField("Description", text: self.$descp).padding()
            DatePicker(selection: $end, in: Date()..., displayedComponents: .date) {
                Text("")
            }.padding()
            Button("Send") {
                guard let req = Config.getRequest(path: "/challenges", method: "POST") else { return }
                let json = [
                    "title": self.title,
                    "description": self.descp,
                    "endDate": "\(self.end)",
                    "isActive": true,
                    "outcome": false,
                    "proofUrl": "",
                    "author": "\(Config.session?.id)"
                    ] as [String : Any]
                if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []) {
                    URLSession.shared.uploadTask(with: req, from: jsonData) { data, resp, err in
                        if let httpResp = resp as? HTTPURLResponse {
                            if httpResp.statusCode == 200 {
                                self.navhappen.toggle()
                            }
                        }
                    }.resume()
                }
            }
            Spacer()
        }
    }
}

struct ChallangeView_Previews: PreviewProvider {
    static var previews: some View {
        ChallangeViewWrapper()
    }
    
    struct ChallangeViewWrapper: View {
        @State var content: String = "challange"
        init() {
            Config.session = User("5ad43c99-bf80-5a1e-aa2e-85b5ce42f08f", email: "", firstname: "First", lastname: "Last", pictureUrl: "", password: "")
        }
        var body: some View {
            ChallangeView(content: self.$content)
        }
    }
}
