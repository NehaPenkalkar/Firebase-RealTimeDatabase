//
//  userValue.swift
//  FirebaseAuthentication
//
//  Created by Neha Penkalkar on 04/05/21.
//

import Foundation

class userValue: NSObject{
    var id: String
    var firstName: String
    var lastname: String
    
    init(id: String, firstName: String, lastname: String){
        self.id = id
        self.firstName = firstName
        self.lastname = lastname
    }
}
