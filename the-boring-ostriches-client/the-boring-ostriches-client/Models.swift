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

class User {
    private var id: String = ""
    private var isDeleted: Bool = false
    var email: String = ""
    var firstName: String = ""
    var lastName: String = ""
    private var pictureUrl: String = ""
}

class Challange {
    private var id: String = ""
    private var isDeleted: Bool = false
    private var author: String = ""
    private var title: String = ""
    private var description: String = ""
    private var isActive: Bool = false
    private var endDate: Date = Date.init() // TODO maybe string
    private var outcome: Bool = false
    private var proofUrl: String = ""
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
