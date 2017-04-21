//
//  User.swift
//  Skeleton
//
//  Created by Dan Finn on 4/21/17.
//  Copyright © 2017 JohnGarza. All rights reserved.
//

import Foundation
import AWSDynamoDB

class User : AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    var userID: String = ""
    var Username: String = ""
    var passwordHash: String = ""
    
    
    class func hashKeyAttribute() -> String {
        return "Username"
    }
    
    class func dynamoDBTableName() -> String {
        return "Users"
    }

}
