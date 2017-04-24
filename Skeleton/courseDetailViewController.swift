//
//  courseDetailViewController.swift
//  Skeleton
//
//  Created by Dan Finn on 4/10/17.
//  Copyright © 2017 JohnGarza. All rights reserved.
//

import UIKit
import KYCircularProgress

class courseDetailViewController: UIViewController {
    
    var incomingCourseCode = ""
    var prevFavorite: Favorite?
    let dbAccessor = DBManager(poolID: "us-east-1:63f21831-90a5-433e-bcee-4ece294731bd")
    
    
    @IBOutlet weak var courseNavTitle: UINavigationItem!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var descriptionArea: UITextView!
    
    @IBOutlet weak var favoriteBtnView: UIView!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var reviewBtnView: UIView!
    @IBOutlet weak var reviewBtn: UIButton!
    
    @IBOutlet weak var overallCircleView: KYCircularProgress!
    @IBOutlet weak var gradingCircleView: KYCircularProgress!
    @IBOutlet weak var workloadCircleView: KYCircularProgress!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        overallCircleView.showGuide = true
        gradingCircleView.showGuide = true
        workloadCircleView.showGuide = true
        
        overallCircleView.startAngle = 3*Double.pi / 2.0
        gradingCircleView.startAngle = 3*Double.pi / 2.0
        workloadCircleView.startAngle = 3*Double.pi / 2.0
        
        overallCircleView.endAngle = 3*Double.pi / 2.0
        gradingCircleView.endAngle = 3*Double.pi / 2.0
        workloadCircleView.endAngle = 3*Double.pi / 2.0
        
        overallCircleView.guideColor = UIColor.darkGray
        gradingCircleView.guideColor = UIColor.darkGray
        workloadCircleView.guideColor = UIColor.darkGray
        
        favoriteBtnView.layer.backgroundColor = UIColor(hue: 0.5778, saturation: 0.93, brightness: 0.9, alpha: 1.0).cgColor
        
        reviewBtnView.layer.backgroundColor = UIColor(hue: 0.5778, saturation: 0.93, brightness: 0.9, alpha: 1.0).cgColor
        
        favoriteBtn.setTitleColor(UIColor.white, for: .normal)
        reviewBtn.setTitleColor(UIColor.white, for: .normal)
        descriptionArea.isEditable = false
        print(incomingCourseCode)
        self.titleLabel.preferredMaxLayoutWidth = self.view.frame.width
        self.titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.titleLabel.numberOfLines = 2
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            
        if let fetchedCourse = self.dbAccessor.getCourse(courseCode: self.incomingCourseCode) {
            
            DispatchQueue.main.async {
                
            
            self.courseNavTitle.title = fetchedCourse.Title
            self.titleLabel.text = fetchedCourse.Title
            self.titleLabel.sizeToFit()
            self.codeLabel.text = fetchedCourse.Code
            self.descriptionArea.text = fetchedCourse.Description
                
            }
        }
            
            if let pulledReviews = self.dbAccessor.scanReviews(code: self.incomingCourseCode){
                var overallTotal = 0
                var gradingTotal = 0
                var workloadTotal = 0
                
                for review in pulledReviews {
                    overallTotal += review.overall
                    gradingTotal += review.grading
                    workloadTotal += review.workload
                }
                
                if pulledReviews.count != 0{
                
                let averageOverall = Double(overallTotal) / Double(pulledReviews.count)
                let averageGrading = Double(gradingTotal) / Double(pulledReviews.count)
                let averageWorkload = Double(workloadTotal) / Double(pulledReviews.count)
                
                DispatchQueue.main.async {
                    let overallColor = self.getColorFromValue(value: Int(averageOverall))
                    self.overallCircleView.colors = [overallColor, overallColor, overallColor]
                    self.overallCircleView.progress = averageOverall / 10.0
                    
                    let gradingColor = self.getColorFromValue(value: 10-Int(averageGrading))
                    
                    self.gradingCircleView.colors = [gradingColor, gradingColor, gradingColor]
                    
                    self.gradingCircleView.progress = averageGrading / 10.0
                    
                    let workloadColor = self.getColorFromValue(value: 10-Int(averageWorkload))
                    
                    self.workloadCircleView.colors = [workloadColor, workloadColor, workloadColor]
                    
                    self.workloadCircleView.progress = averageWorkload / 10.0
                    
                    
                    
                 }
                }
                
            }
        
            if (UserDefaults.standard.bool(forKey: "rmcSignedIn")){
                if let curUser = self.dbAccessor.getUser(Username: UserDefaults.standard.string(forKey: "rmcUsername")!) {
                    if let fav = self.dbAccessor.getFavorite(code: self.codeLabel.text!, user: curUser) {
                        
                        self.prevFavorite = fav
                        DispatchQueue.main.async {
                            self.favoriteBtn.setTitle("Unfavorite", for: .normal)
                        }
                    }
                }
            
            }
        
    }

}
    
    @IBAction func favoriteCourse(_ sender: UIButton) {
        if sender.titleLabel?.text == "Unfavorite" {
            print("somehow got here idk how")
            let mapper = dbAccessor.getMapperObject()
            mapper.remove(self.prevFavorite!)
            favoriteBtn.setTitle("Favorite", for: .normal)
            
            return
            
        }
        
        if(!UserDefaults.standard.bool(forKey: "rmcSignedIn")){
            self.performSegue(withIdentifier: "toSignInView", sender: self)
            return
        }
        let newFavorite = Favorite()
        guard let curUser = dbAccessor.getUser(Username: UserDefaults.standard.string(forKey: "rmcUsername")!) else {return}
        
        newFavorite?.Code = codeLabel.text!
        newFavorite?.user_id = curUser.userID
        
        self.prevFavorite = newFavorite
        
        favoriteBtn.setTitle("Unfavorite", for: .normal)
        _ = dbAccessor.addFavorite(favorite: newFavorite!)
        
        
    }
    
    @IBAction func prepareForNewReview(){
        if(UserDefaults.standard.bool(forKey: "rmcSignedIn")){
            self.performSegue(withIdentifier: "newReviewSegue", sender: self)
        } else {
            self.performSegue(withIdentifier: "toSignInView", sender: self)
        }
    }

    
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newReviewSegue" {
            print("we still got here just didnt do it")
            let destVC = segue.destination as! createReviewViewController
            destVC.incomingCourseTitle = titleLabel.text!
            destVC.incomingCourseCode = codeLabel.text!
            
        }
        
        if segue.identifier == "toReviewView" {
            let destVC = segue.destination as! ReviewsView
            destVC.incomingCourseCode = codeLabel.text!
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "newReviewSegue"{
            return UserDefaults.standard.bool(forKey: "rmcSignedIn")
        }
        
        return true
    }
    
    func getColorFromValue(value: Int) -> UIColor {
        if (value < 4){
            return UIColor.red
        }
        
        if (value < 7){
            return UIColor(hue: 0.1389, saturation: 1, brightness: 1, alpha: 1.0)
        }
        return UIColor.green
        
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
