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
    var body: some View {
        NavigationView{
            List(self.challanges) { challange in
                ChallangeRow(challange: challange)
            }
        }.onAppear(perform: loadData)
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
            Spacer()
            Text(challange.description).font(.body)
            .padding()
        }.navigationBarTitle("\(Config.session!.firstName) \(Config.session!.lastName)")
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
