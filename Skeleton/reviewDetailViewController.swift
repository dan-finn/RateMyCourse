//
//  reviewDetailViewController.swift
//  Skeleton
//
//  Created by Dan Finn on 4/23/17.
//  Copyright © 2017 JohnGarza. All rights reserved.
//

import UIKit

class reviewDetailViewController: UIViewController {
    
    var incomingData = ""
    let dbAccessor = DBManager(poolID: "us-east-1:63f21831-90a5-433e-bcee-4ece294731bd")
    
    @IBOutlet weak var editBtn: UIBarButtonItem!
    @IBOutlet weak var commentsTextView: UITextView!
    @IBOutlet weak var workloadDisplayView: DisplayView!
    @IBOutlet weak var workloadVal: UILabel!
    @IBOutlet weak var overallDisplayView: DisplayView!
    @IBOutlet weak var overallVal: UILabel!
    @IBOutlet weak var gradingVal: UILabel!
    @IBOutlet weak var professorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reviewView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var gradingDisplayView: DisplayView!
    var oldBtn: UIBarButtonItem! = UIBarButtonItem()
    var courseCode = ""
    var hasLoaded = false
    override func viewDidLoad() {
        super.viewDidLoad()
        commentsTextView.isEditable = false
        commentsTextView.text = ""
        oldBtn = editBtn
        navigationItem.rightBarButtonItem = nil
        commentsTextView.layer.borderWidth = 2
        commentsTextView.layer.cornerRadius = 5
        commentsTextView.layer.borderColor = UIColor(hue: 0.55, saturation: 1, brightness: 0.97, alpha: 1.0).cgColor
        commentsTextView.layer.backgroundColor = UIColor(hue: 0.55, saturation: 1, brightness: 0.97, alpha: 0.5).cgColor
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        getAndSetData()
       
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAndSetData(){
        var dataArray = incomingData.components(separatedBy: "|")
        let courseCode = dataArray[0]
        let userID = dataArray[1]
        
        DispatchQueue.global(qos: .background).async {
            
            
            guard let targetCourse = self.dbAccessor.getCourse(courseCode: courseCode) else {self.dismiss(animated: true, completion: nil); return}
            guard let targetReview = self.dbAccessor.getReview(code: courseCode, user_id: userID) else {self.dismiss(animated: true, completion: nil); return}
            
            if (UserDefaults.standard.bool(forKey: "rmcSignedIn")){
                print("here1")

                if let curUser = self.dbAccessor.getUser(Username: UserDefaults.standard.string(forKey: "rmcUsername")!) {
                    print("here2")
                    if curUser.userID == targetReview.user_id {
                        DispatchQueue.main.async {
                            print("here")
                            self.navigationItem.rightBarButtonItem = self.oldBtn
                            self.courseCode = targetCourse.Code
                        }
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.titleLabel.text = targetCourse.Title
                self.professorLabel.text = "Professor: \(targetReview.professors)"
                self.overallVal.text = String(targetReview.overall)
                self.overallDisplayView.value = CGFloat(Double(targetReview.overall) / 10.0)
                self.overallDisplayView.color = self.getColorFromValue(value: targetReview.overall)
                
                self.gradingVal.text = String(targetReview.grading)
                self.gradingDisplayView.value = CGFloat(Double(targetReview.grading) / 10.0)
                self.gradingDisplayView.color = self.getColorFromValue(value: 10-targetReview.grading)
                
                self.workloadVal.text = String(targetReview.workload)
                self.workloadDisplayView.value = CGFloat(Double(targetReview.workload) / 10.0)
                
                self.workloadDisplayView.color = self.getColorFromValue(value: (10-targetReview.workload))
                
                if targetReview.comments != "Insert comments... (optional)"{
                    self.commentsTextView.text = targetReview.comments
                } else {
                    self.commentsTextView.text = "No comments provided"
                }
                self.reviewView.isHidden = false
                self.spinner.stopAnimating()
                self.spinner.isHidden = false
            }
            
        }
        
        
        
    }
    
    func getColorFromValue(value: Int) -> UIColor {
        if (value < 4){
            return UIColor.red
        }
        
        if (value < 7){
            return UIColor.yellow
        }
        
        return UIColor.green
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditReview"{
            let destVC = segue.destination as! createReviewViewController
            destVC.incomingCourseCode = self.courseCode
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (hasLoaded){
        self.viewDidLoad()
        }
        hasLoaded = true
    }

    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
