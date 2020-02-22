//
//  Models.swift
//  the-boring-ostriches-client
//
//  Created by Robert Boros on 2020. 02. 22..
//  Copyright © 2020. Robert Boros. All rights reserved.
//

import Foundation
import Combine

class UserAuth: ObservableObject {
    
    let objectWillChange = PassthroughSubject<UserAuth,Never>()
    
    @Published var username: String = "" {
        willSet{ self.objectWillChange.send(self) }
    }
    @Published var isLoggedin: Bool = false {
        willSet{ self.objectWillChange.send(self) }
    }
}

class User: Decodable {
    var id: String = ""
    var isDeleted: Bool = false
    var email: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var pictureUrl: String = ""
    var password: String = ""
    init(_ id: String, email: String, firstname: String, lastname: String, pictureUrl: String, password: String) {
        self.id = id
        self.email = email
        self.firstName = firstname
        self.lastName = lastname
        self.pictureUrl = pictureUrl
        self.password = password
    }
}

class Challange: Identifiable, Decodable {
    var id: String = ""
    var isDeleted: Bool = false
    var author: String = ""
    var title: String = ""
    var description: String = ""
    // var isActive: Bool = false
    var endDate: String = "" // TODO maybe string
    var outcome: Bool = false
    var proofUrl: String = ""
}

class Bet {
    private var id: String = ""
    private var isDeleted: Bool = false
    private var author: String = ""
    private var challenge: String = ""
    private var inFavor: Bool = false
    private var amount: UInt64 = 0
    private var result: Int64 = 0
}
