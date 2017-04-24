//
//  settingsViewController.swift
//  Skeleton
//
//  Created by Dan Finn on 4/23/17.
//  Copyright © 2017 JohnGarza. All rights reserved.
//

import UIKit

class settingsViewController: UIViewController {

    @IBOutlet weak var changePwBtnView: UIView!
    @IBOutlet weak var changePwBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        changePwBtnView.layer.backgroundColor = UIColor.red.cgColor
        changePwBtn.setTitleColor(UIColor.white, for: .normal)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
