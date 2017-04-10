//
//  Course.swift
//  RateMyCourse
//
//  Created by Dan Finn on 4/7/17.
//  Copyright © 2017 Dan Finn. All rights reserved.
//

import Foundation
import AWSDynamoDB

class Course : AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    var Code: String = ""
    var Description: String = ""
    var Title: String = ""
    
    class func dynamoDBTableName() -> String {
        return "Courses";
    }
    
    class func hashKeyAttribute() -> String {
        return "Code"
    }
    
    
    
}
