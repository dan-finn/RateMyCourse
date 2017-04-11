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

    @IBOutlet weak var courseNavTitle: UINavigationItem!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var descriptionArea: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionArea.isEditable = false
        print(incomingCourseCode)
    
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
