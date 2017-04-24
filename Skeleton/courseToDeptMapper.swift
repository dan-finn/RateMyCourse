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
    var engineeringDeptNameArray = ["All", "Biomedical", "Computer", "Electrical", "Systems", "Energy and Environmental", "Chemical", "General", "Mechanical"]
    
    var engineeringDeptCodeArray = ["", "E62", "E81", "E35", "E35", "E44", "E44", "E60", "E37"]
    
    var artSciDeptNameArray = ["All","African and African-American Studies","American Culture Studies","Anthropology","Arabic","Archaeology","Art History and Archaeology","Asian American Studies","Biology and Biomedical Sciences","Center for the Humanities","Chemistry","Children's Studies","Chinese","Classics","College Writing Program","Comparative Literature","Dance","Drama","Earth and Planetary Sciences","East Asian Studies","Economics","Education","English Literature","Environmental Studies","European Studies","Film and Media Studies","Focus","French","General Studies","Germanic Languages and Literatures","Greek","Hebrew","Hindi","History","Interdisciplinary Project In The Humanities","International and Area Studies","Italian","Japanese","Jewish, Islamic and Near Eastern Studies","Korean","Latin American Studies","Latin","Legal Studies","Linguistics","Mathematics","Mind, Brain, and Behavior","Movement Science","Music","Medical Humanities","Overseas Programs","Pathfinder Program","Persian","Philosophy","Philosophy-Neuroscience-Psychology","Physical Education","Physics","Political Economy","Political Science","Portuguese","Praxis","Psychological and Brain Sciences","Religion and Politics","Religious Studies","Romance Languages and Literatures","Russian Studies","Russian","Sociology","Spanish","Speech and Hearing","Urban Studies","Women, Gender, and Sexuality Studies","Writing"]
    
    var artSciDeptCodeArray = ["","L90", "L98", "L48", "L49", "L52", "L01", "L46", "L41", "L56", "L07", "L66", "L04", "L08", "L59", "L16", "L29", "L15", "L19", "L03", "L11", "L12", "L14", "L82", "L79", "L53", "L61", "L34", "L43", "L21", "L09", "L74", "L73", "L22", "L93", "L97", "L36", "L05", "L75", "L51", "L45", "L10", "L84", "L44", "L24", "L96", "L63", "L27", "L85", "L99", "L54", "L47", "L30", "L64", "L28", "L31", "L50", "L32", "L37", "L62", "L33", "L57", "L23", "L78", "L83", "L39", "L40", "L38", "L89", "L18", "L77", "L13"]
    
    var olinDeptNameArray = ["All","Accounting (Undergrad)", "Accounting (Grad)", "Administration", "Finance (Undergrad)", "Finance (Grad)", "Human Resource Management", "International Studies", "Management (Undergrad)", "Management (Grad)", "Managerial Economics (Undergrad)", "Managerial Economics (Grad)", "Marketing (Undergrad)", "Marketing (Grad)", "Oper & Manufacturing Mgmt (Undergrad)", "Oper & Manufacturing Mgmt (Grad)", "Operations And Supply Chain Management", "Organizational Behavior", "Quantitative Bus Analysis"]
    
    var olinDeptCodeArray = ["", "B50", "B60", "B51", "B52", "B62", "B56", "B99", "B53", "B63", "B54", "B64", "B55", "B65", "B57", "B67", "B58", "B66", "B59"]
    
    
    
    init(){
        for i in 1..<engineeringDeptNameArray.count {
            dictionary[engineeringDeptNameArray[i]] = engineeringDeptCodeArray[i]
        }
        
        for i in 1..<artSciDeptNameArray.count {
            dictionary[artSciDeptNameArray[i]] = artSciDeptCodeArray[i]
        }
        
        for i in 1..<olinDeptNameArray.count {
            dictionary[olinDeptNameArray[i]] = olinDeptCodeArray[i]
        }
    
    }
    
    func getCodeFromDeptName(name: String) -> String {
        return dictionary[name]!
    }
    
    
    


}
