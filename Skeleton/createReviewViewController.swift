//
//  createReviewViewController.swift
//  Skeleton
//
//  Created by Dan Finn on 4/16/17.
//  Copyright © 2017 JohnGarza. All rights reserved.
//

import UIKit

class createReviewViewController: UIViewController, UITextViewDelegate {

    let sliderStep = CGFloat(1)
    
    var placeHolderText = "Insert comments... (optional)"
    
    @IBOutlet weak var theScrollView: UIScrollView!
    var incomingCourseTitle = ""
    var incomingCourseCode = ""
    var userHasSubmittedPrevReview = false
    
    let dbAccessor = DBManager(poolID: "us-east-1:63f21831-90a5-433e-bcee-4ece294731bd")
   
    @IBOutlet weak var profTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overallRatingVal: UILabel!
    @IBOutlet weak var overallRatingSlider: UISlider!
    
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var gradingDifVal: UILabel!
    
    @IBOutlet weak var gradingDifSlider: UISlider!
    
    @IBOutlet weak var workloadSlider: UISlider!
    @IBOutlet weak var workloadVal: UILabel!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var deleteReviewView: UIView!
    
    @IBOutlet weak var deleteReviewBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        titleLabel.text = incomingCourseTitle
        reviewTextView.delegate = self
        reviewTextView.text = placeHolderText
        profTextField.placeholder = "Prof 1, Prof 2, Prof 3"
        reviewTextView.layer.borderColor = UIColor.lightGray.cgColor
        reviewTextView.textColor = UIColor.lightGray
        
        deleteReviewBtn.setTitleColor(UIColor.white, for: .normal)
        deleteReviewView.layer.backgroundColor = UIColor.red.cgColor
        
        
        
        let isSignedIn = UserDefaults.standard.bool(forKey: "rmcSignedIn")
        print(isSignedIn)
        
        guard let curUser = dbAccessor.getUser(Username: UserDefaults.standard.string(forKey: "rmcUsername")!) else {dismiss(animated: true, completion: nil); return}
        
        if let prevReview = dbAccessor.getReview(code: incomingCourseCode, user: curUser) {
            userHasSubmittedPrevReview = true
            overallRatingVal.text = String(prevReview.overall)
            overallRatingSlider.value = Float(prevReview.overall)
            
            gradingDifVal.text = String(prevReview.grading)
            gradingDifSlider.value = Float(prevReview.grading)
            
            workloadVal.text = String(prevReview.workload)
            workloadSlider.value = Float(prevReview.workload)
            
            profTextField.text = prevReview.professors
            reviewTextView.text = prevReview.comments
            self.placeHolderText = prevReview.comments
            deleteReviewView.isHidden = false
            
        
        }
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        singleTap.numberOfTapsRequired = 1
        
        view.addGestureRecognizer(singleTap)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeModalView(){
        self.dismiss(animated: true, completion: nil)
    
    }
    
    func closeModalViewFromAlert(alert: UIAlertAction!){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postReview(){
        let curUser = dbAccessor.getUser(Username: UserDefaults.standard.string(forKey: "rmcUsername")!)

        if (userHasSubmittedPrevReview){
            let mapper = dbAccessor.getMapperObject()
            let prevView = dbAccessor.getReview(code: incomingCourseCode, user: curUser!)
            mapper.remove(prevView!)
        }
        
        let new_review = Review()
        
        new_review?.Code = incomingCourseCode
       
        /*if (reviewTextView.text != placeHolderText){
            new_review?.comments = reviewTextView.text
        }*/
        
        new_review?.comments = reviewTextView.text
        if (new_review?.comments == ""){
            new_review?.comments = "*"
        }
        
        var overall = 0
        var grading = 0
        var workload = 0
        overall = Int(overallRatingSlider.value)
        grading = Int(gradingDifSlider.value)
        workload = Int(workloadSlider.value)
        
        if (overall == 0 || grading == 0 || workload == 0 || profTextField.text! == ""){
            let alertControl = UIAlertController(title: "ERROR", message: "Please fill out all fields", preferredStyle: .alert)
            
            let alertAction = UIAlertAction(title: "OKAY", style: .default, handler: nil)
            alertControl.addAction(alertAction)
            present(alertControl, animated: true, completion: nil)
            return
        }
        
        guard let professors = profTextField.text else {return}
        
        new_review?.professors = professors
        new_review?.overall = overall
        new_review?.grading = grading
        new_review?.workload = workload
        new_review?.id = UUID().uuidString
        new_review?.user_id = (curUser?.userID)!
        
        
        let userIsSignedIn = UserDefaults.standard.bool(forKey: "rmcSignedIn")
        
        if (userIsSignedIn){
            DispatchQueue.global(qos: .userInitiated).async{
                print(self.dbAccessor.addReview(review: new_review!))
            }
        }
        
        let alertControl = UIAlertController(title: "Review Posted", message: "Review sent to database!", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OKAY", style: .default, handler: closeModalViewFromAlert)
        alertControl.addAction(alertAction)
        present(alertControl, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func updateLabel(_ sender: UISlider) {
        let roundedVal = Int(sender.value)
        sender.value = Float(roundedVal)
        
        if (sender == overallRatingSlider){
            overallRatingVal.text = String(roundedVal)
        }
        if (sender == gradingDifSlider) {
            gradingDifVal.text = String(roundedVal)
        }
        if (sender == workloadSlider){
            workloadVal.text = String(roundedVal)
        }
        
        
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text != placeHolderText {
            return
        }
        textView.text = ""
        textView.textColor = UIColor.black
        textView.layer.borderColor = UIColor.gray.cgColor
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = placeHolderText
            textView.textColor = UIColor.lightGray
        }
        textView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        reviewTextView.resignFirstResponder()
    }
    
    @IBAction func deleteReview(){
        guard let curUser = dbAccessor.getUser(Username: UserDefaults.standard.string(forKey: "rmcUsername")!) else {return}
        
        if let prevReview = dbAccessor.getReview(code: incomingCourseCode, user: curUser) {
            let mapper = dbAccessor.getMapperObject()
            mapper.remove(prevReview)
            self.dismiss(animated: true, completion: nil)
        
        }
        
        
        
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
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
