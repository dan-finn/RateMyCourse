//
//  DBManager.swift
//  RateMyCourse
//
//  Created by Dan Finn on 4/7/17.
//  Copyright © 2017 Dan Finn. All rights reserved.
//
// @author Daniel Finn dmfinn@wustl.edu
// Provides a object that allows pretty and clean interactions with our database;
import Foundation
import AWSDynamoDB
import AWSCore
import AWSCognito

class DBManager {
    var poolID:String?
    var credentials:AWSCognitoCredentialsProvider?
    var dbMapper: AWSDynamoDBObjectMapper?
    enum filterTypes {
        case title
        case department
        case credits
        case code
    }
    
    init(poolID: String){
        
        // generate our credentials from the pool ID
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityPoolId: poolID)
        
        // create our configuration and set it as the default
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        // set our save configuration to prevent null deletes
        //TODO
        
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        
        self.dbMapper = dynamoDBObjectMapper
        
        
        
    }
    
    func getCourse(courseCode: String) -> Course? {
        
        // set up our monitoring and returning variables
        // var fetchedCourse:Course?
        var fetchComplete = false
        var grabbedCourse:Course?
        
        // load data from CourseCode string
        dbMapper?.load(Course.self, hashKey: courseCode, rangeKey:nil).continueWith(block: { (task:AWSTask<AnyObject>!) -> Course? in
            if let error = task.error as? NSError {
                print("The request failed. Error: \(error)")
                return nil
            } else if let resultCourse = task.result as? Course {
                grabbedCourse = resultCourse
            }
            fetchComplete = true
            return nil
            
        })
        
        // block until the fetch is complete
        while(!fetchComplete){}
        return grabbedCourse
    }
    
    func getUser(Username: String) -> User? {
        var fetchComplete = false
        var fetchedUser: User?
        dbMapper?.load(User.self, hashKey: Username, rangeKey: nil).continueWith(block: { (task:AWSTask<AnyObject>!) -> User? in
            if let error = task.error as? NSError {
                print("The request failed. Error: \(error)")
                return nil
            } else if let resultUser = task.result as? User {
                fetchedUser = resultUser
            }
            fetchComplete = true
            return nil
            
        })
        
        // block until the fetch is complete
        while(!fetchComplete){}
        return fetchedUser

        
    }
    
    
    func getMapperObject() -> AWSDynamoDBObjectMapper {
        return self.dbMapper!
    }
    
    
    // depreciated
    func searchCourses(title: String ) -> [Course] {
        let scanExpression = AWSDynamoDBScanExpression();
        scanExpression.filterExpression = "contains(Title,:val)"
        scanExpression.expressionAttributeValues = [":val": title]
        
        var scanResults = [Course]()
        var fetched = false;
        
        dbMapper?.scan(Course.self, expression: scanExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
            if let error = task.error as? NSError {
                print("The request failed. Error: \(error)")
            } else if let paginatedOutput = task.result {
                for course in paginatedOutput.items as! [Course] {
                    scanResults.append(course)
                }
            }
            fetched = true;
            return nil
        })
        while (!fetched){}
        return scanResults
        
    }
    // end depreciated
    
    func scanCourses(query: String, focuser: String, filter: filterTypes ) -> [Course]? {
        let scanExpression = AWSDynamoDBScanExpression()
        var scanResults = [Course]()
        var fetched = false
        
        switch filter {
        case .title:
            if focuser != "" {
            scanExpression.filterExpression = "contains(Title, :val) AND begins_with(Code, :val1)"
            } else {
            scanExpression.filterExpression = "contains(Title, :val)"
            }
            break
        case .code:
            scanExpression.filterExpression = "Code = :val"
            break
        case .credits:
            scanExpression.filterExpression = "Credits = :val"
            break
        case .department:
            scanExpression.filterExpression = "Code BEGINS :val"
        }
        
        if focuser != "" {
        scanExpression.expressionAttributeValues = [":val": query, ":val1": focuser]
        } else {
            scanExpression.expressionAttributeValues = [":val": query]
        }
        
        dbMapper?.scan(Course.self, expression: scanExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
            if let error = task.error as? NSError {
                print("The request failed. Error: \(error)")
            } else if let paginatedOutput = task.result {
                for course in paginatedOutput.items as! [Course] {
                    scanResults.append(course)
                }
            }
            fetched = true;
            return nil
        })
        while (!fetched){}
        return scanResults
        
        
    }
    
    func scanFavoritesForUser(user: User) -> [Favorite]? {
        let scanExpression = AWSDynamoDBScanExpression()
        var scanResults = [Favorite]()
        var fetched = false
        
        scanExpression.filterExpression = "user_id = :val"
        scanExpression.expressionAttributeValues = [":val" : user.userID ]
        dbMapper?.scan(Favorite.self, expression: scanExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
            if let error = task.error as? NSError {
                print("The request failed. Error: \(error)")
            } else if let paginatedOutput = task.result {
                for favorite in paginatedOutput.items as! [Favorite] {
                    scanResults.append(favorite)
                }
            }
            fetched = true;
            return nil
        })
        while (!fetched){}
        return scanResults

    
    }
    
    func scanReviews(code: String) -> [Review]? {
        let scanExpression = AWSDynamoDBScanExpression()
        var scanResults = [Review]()
        var fetched = false
        scanExpression.filterExpression = "Code = :val"
        scanExpression.expressionAttributeValues = [":val": code]
        
        dbMapper?.scan(Review.self, expression: scanExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
            if let error = task.error as? NSError {
                print("The request failed. Error: \(error)")
            } else if let paginatedOutput = task.result {
                for review in paginatedOutput.items as! [Review] {
                    scanResults.append(review)
                }
            }
            fetched = true;
            return nil
        })
        while (!fetched){}
        return scanResults
    
    }
    
    func addCourse(course: Course) -> Bool {
        
        _ = false
        
        let success = dbMapper?.save(course).continueWith(block: { (task: AWSTask<AnyObject>! ) -> Bool? in
            if let error = task.error as? NSError {
                print("Save request failed with error: \(error)")
                return nil;
            } else {
                return true
                
            }
        })
        
        return (success != nil)
    }
    
    func addReview(review: Review) -> Bool {
        let success = dbMapper?.save(review).continueWith(block: { (task: AWSTask<AnyObject>! ) -> Bool? in
            if let error = task.error as? NSError {
                print("Save request failed with error: \(error)")
                return nil;
            } else {
                return true
                
            }
        })
        
        return (success != nil)
    }
    
    func addFavorite(favorite: Favorite) -> Bool {
        let success = dbMapper?.save(favorite).continueWith(block: { (task: AWSTask<AnyObject>! ) -> Bool? in
            if let error = task.error as? NSError {
                print("Save request failed with error: \(error)")
                return nil;
            } else {
                return true
                
            }
        })
        
        return (success != nil)

    }
    
    
    func addUser(user: User) -> Bool {
        let success = dbMapper?.save(user).continueWith(block: { (task: AWSTask<AnyObject>! ) -> Bool? in
            if let error = task.error as? NSError {
                print("Save request failed with error: \(error)")
                return nil;
            } else {
                return true
                
            }
        })
        
        return (success != nil)
    }
    
    func getReview(code: String, user: User) -> Review? {
        var fetchComplete = false
        var grabbedReview:Review?
        
        // load data from CourseCode string
        dbMapper?.load(Review.self, hashKey: code, rangeKey: user.userID).continueWith(block: { (task:AWSTask<AnyObject>!) -> Review? in
            if let error = task.error as? NSError {
                print("The request failed. Error: \(error)")
                return nil
            } else if let resultReview = task.result as? Review {
                grabbedReview = resultReview
            }
            fetchComplete = true
            return nil
            
        })
        
        // block until the fetch is complete
        while(!fetchComplete){}
        return grabbedReview
        
    
    }
    
    func getFavorite(code: String, user: User) -> Favorite? {
        var fetchComplete = false
        var grabbedFavorite:Favorite?
        
        // load data from CourseCode string
        dbMapper?.load(Favorite.self, hashKey: user.userID, rangeKey: code).continueWith(block: { (task:AWSTask<AnyObject>!) -> Favorite? in
            if let error = task.error as? NSError {
                print("The request failed. Error: \(error)")
                return nil
            } else if let resultFavorite = task.result as? Favorite {
                grabbedFavorite = resultFavorite
            }
            fetchComplete = true
            return nil
            
        })
        
        // block until the fetch is complete
        while(!fetchComplete){}
        return grabbedFavorite

    
    }

    
    
}
