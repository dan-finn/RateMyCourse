//
//  courseDetailViewController.swift
//  Skeleton
//
//  Created by Dan Finn on 4/10/17.
//  Copyright © 2017 JohnGarza. All rights reserved.
//

import UIKit

class courseDetailViewController: UIViewController {
    
    var incomingCourseCode = ""
    var prevFavorite: Favorite?
    let dbAccessor = DBManager(poolID: "us-east-1:63f21831-90a5-433e-bcee-4ece294731bd")
    
    
    @IBOutlet weak var courseNavTitle: UINavigationItem!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var descriptionArea: UITextView!
    
    @IBOutlet weak var favoriteBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
