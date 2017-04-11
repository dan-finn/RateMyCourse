//
//  ResultsView.swift
//  Skeleton
//
//  Created by student4342 on 4/9/17.
//  Copyright © 2017 JohnGarza. All rights reserved.
//

import UIKit

class ResultsView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var theTableView: UITableView!
    @IBOutlet weak var searchTitle: UINavigationItem!
    @IBOutlet weak var dataResults: UILabel!
    var querySent = ""
    let dbAccessor = DBManager(poolID: "us-east-1:63f21831-90a5-433e-bcee-4ece294731bd")
    let searchResults = [Course]()
    var sampleData: [Course] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(querySent)
        searchTitle.title = querySent
        
        self.theTableView.delegate = self
        self.theTableView.dataSource = self
        
        
        let myCourse = Course()
        myCourse?.Title = "TEST"
        myCourse?.Code = "TEST TEST"
        myCourse?.Description = "TEST TEST TEST"
        
        
        /*DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async{
            if let searchResults = self.dbAccessor.scanCourses(query: self.querySent, filter: .title){
                for course in searchResults {
                    print(course.Title)
                }
            }
            
        
        }*/
        
        self.theTableView.reloadData()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getResults(){
        
        if let fetchedResults = dbAccessor.scanCourses(query: querySent, filter: .title){
            for course in fetchedResults {
                self.sampleData.append(course)
            }
        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sampleData.count;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        print("Selected Course Title: \(self.sampleData[indexPath.row].Title)")
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.theTableView.dequeueReusableCell(withIdentifier: "searchResultsCell")! as UITableViewCell
        let theCourse = sampleData[indexPath.row]
        let theLabel = cell.contentView.viewWithTag(1) as! UILabel
        let hiddenCodeLabel = cell.contentView.viewWithTag(2) as! UILabel
        
        hiddenCodeLabel.text = theCourse.Code
        theLabel.text = theCourse.Title
        
        return cell
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.sampleData = []
        getResults()
        theTableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let sendingCell = sender as! UITableViewCell
        
        let destVC = segue.destination as! courseDetailViewController
        
        let codeLabel = sendingCell.contentView.viewWithTag(2) as! UILabel
        
        destVC.incomingCourseCode = codeLabel.text!
        
        
        
        
        
    }
    


    
}
