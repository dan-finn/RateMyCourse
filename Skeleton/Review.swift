//
//  Review.swift
//  Skeleton
//
//  Created by Dan Finn on 4/20/17.
//  Copyright © 2017 JohnGarza. All rights reserved.
//

import Foundation
import AWSDynamoDB

class Review : AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    var id = ""
    var user_id: String = ""
    var Code: String = ""
    var overall: Int = 0
    var grading: Int = 0
    var workload: Int = 0
    var professors: String = ""
    var comments: String = ""
    

    class func dynamoDBTableName() -> String {
        return "Reviews"
    }
    class func hashKeyAttribute() -> String {
        return "Code"
    }
    
    class func rangeKeyAttribute() -> String {
        return "user_id"
    }
    
}
