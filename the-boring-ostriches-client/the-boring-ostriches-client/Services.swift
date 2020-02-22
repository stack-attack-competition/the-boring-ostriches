//
//  AuthService.swift
//  the-boring-ostriches-client
//
//  Created by Robert Boros on 2020. 02. 22..
//  Copyright © 2020. Robert Boros. All rights reserved.
//

import Foundation

class Config {
    static let baseURL = "https://stack-attack-bed.herokuapp.com"
    
    static var session: User? = nil
    
    static func getRequest(path: String, method: String) -> URLRequest? {
        guard let url = URL(string: "\(baseURL)\(path)") else { return nil }
        var req = URLRequest(url: url)
        req.httpMethod = method
        req.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        return req
    }
}

class AuthService: ObservableObject {
    
}
