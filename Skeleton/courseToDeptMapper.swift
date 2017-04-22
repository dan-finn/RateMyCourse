//
//  courseToDeptMapper.swift
//  Skeleton
//
//  Created by Dan Finn on 4/22/17.
//  Copyright © 2017 JohnGarza. All rights reserved.
//

import Foundation

class courseToDeptMapper {
    var dictionary: Dictionary = [String:String]();
    var engineeringDeptNameArray = ["ALL", "Biomedical", "Computer", "Electrical", "Systems", "Energy and Environmental", "Chemical", "General", "Mechanical"]
    
    var engineeringDeptCodeArray = ["", "E62", "E81", "E35", "E35", "E44", "E44", "E60", "E37"]
    
    
    
    init(){
        for i in 1..<engineeringDeptNameArray.count {
            dictionary[engineeringDeptNameArray[i]] = engineeringDeptCodeArray[i]
        }
    
    }
    
    func getCodeFromDeptName(name: String) -> String {
        return dictionary[name]!
    }
    
    
    


}
