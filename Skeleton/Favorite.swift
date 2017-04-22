//
//  Favorite.swift
//  Skeleton
//
//  Created by Dan Finn on 4/22/17.
//  Copyright © 2017 JohnGarza. All rights reserved.
//

import Foundation
import AWSDynamoDB

class Favorite : AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    var Code: String = ""
    var user_id: String = ""
    
    class func hashKeyAttribute() -> String {
        return "user_id"
    }
    class func rangeKeyAttribute() -> String {
        return "Code"
    }
    
    class func dynamoDBTableName() -> String {
        return "Favorites"
    }
    
}
