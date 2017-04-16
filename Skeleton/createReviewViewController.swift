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
    
    let placeHolderText = "Insert comments... (optional)"
    
    var incomingCourseTitle = ""
   
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
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = incomingCourseTitle
        reviewTextView.delegate = self
        reviewTextView.text = placeHolderText
        profTextField.placeholder = "Prof 1, Prof 2, Prof 3"
        reviewTextView.layer.borderColor = UIColor.lightGray.cgColor
        reviewTextView.textColor = UIColor.lightGray

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeModalView(){
        self.dismiss(animated: true, completion: nil)
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
