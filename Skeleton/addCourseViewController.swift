//
//  addCourseViewController.swift
//  Skeleton
//
//  Created by Dan Finn on 4/22/17.
//  Copyright © 2017 JohnGarza. All rights reserved.
//

import UIKit

class addCourseViewController: UIViewController {

    let dbAccessor = DBManager(poolID: "us-east-1:63f21831-90a5-433e-bcee-4ece294731bd")

    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addReview(){
        print("here")
        guard let code = codeField.text else {return}
        guard let title = titleField.text else {return}
        guard let description = descriptionField.text else {return}
        
        if (code == "" || title == "" || description == ""){
            let alertController = UIAlertController(title: "ERROR", message: "Please fill out all fields", preferredStyle: .alert)
            let confAction = UIAlertAction(title: "OKAY", style: .default, handler: nil)
            
            alertController.addAction(confAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        let codePattern:String = "\\[A-Z]{1}\\d{2}\\s\\w*\\s{0,}\\w*\\s\\d{3,4}\\w{0,}"
        
       // let regex  = try! NSRegularExpression(pattern: codePattern, options: [])
        
        if codePattern.range(of: codePattern) == nil {
            return
        }
        
        if dbAccessor.getCourse(courseCode: code) != nil{
            let alertController = UIAlertController(title: "ERROR", message: "Course already exists!", preferredStyle: .alert)
            let confAction = UIAlertAction(title: "OKAY", style: .default, handler: nil)
            
            alertController.addAction(confAction)
            present(alertController, animated: true, completion: nil)
            return
        
        }
        
        
        let newCourse = Course()
        
        newCourse?.Code = code
        newCourse?.Title = title
        newCourse?.Description = description
        
        print("Added Course")
        
        //_ = dbAccessor.addCourse(course: newCourse!)
        
        
    
    
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
