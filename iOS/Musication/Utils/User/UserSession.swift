//
//  UserSession.swift
//  Musication
//
//  Created by Tiago Oliveira on 12/10/21.
//

import Foundation

class UserSession {
    static var shared: UserSession = {
        let instance = UserSession()
        return instance
    }()
    
    private var userId: String = ""
    
    private init() {
        userId = UUID().uuidString
    }
    
    public func getUserId() -> String {
        return userId
    }
}
