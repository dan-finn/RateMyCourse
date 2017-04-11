//
//  ResultsView.swift
//  Skeleton
//
//  Created by student4342 on 4/9/17.
//  Copyright © 2017 JohnGarza. All rights reserved.
//

import UIKit

class ResultsView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var theTableView: UITableView!
    @IBOutlet weak var searchTitle: UINavigationItem!
    @IBOutlet weak var dataResults: UILabel!
    @IBOutlet weak var notFoundImage: UIImageView!
    var querySent = ""
    var focuserSent = ""
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
        print("Scanning with query \(self.querySent) and with focuser \(self.focuserSent)")
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async{
        if let fetchedResults = self.dbAccessor.scanCourses(query: self.querySent, focuser: self.focuserSent, filter: .title){
            for course in fetchedResults {
                self.sampleData.append(course)
                self.theTableView.reloadData()
            }
            
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
                self.theTableView.isHidden = self.sampleData.count > 0 ? false : true
                self.notFoundImage.isHidden = self.sampleData.count > 0 ? true : false
                self.theTableView.reloadData()
                
            }
            
            
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
        //self.sampleData = []
        if (self.sampleData.count == 0){
        self.spinner.isHidden = false
       self.spinner.startAnimating()
        getResults()
        }
        theTableView.reloadData()
       // self.spinner.stopAnimating()
       // self.theTableView.isHidden = false
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toCourseDetailView" {
        
            let sendingCell = sender as! UITableViewCell
        
            let destVC = segue.destination as! courseDetailViewController
            
            let codeLabel = sendingCell.contentView.viewWithTag(2) as! UILabel
        
            destVC.incomingCourseCode = codeLabel.text!
        
        }
        
        
        
    }
    


    
}
