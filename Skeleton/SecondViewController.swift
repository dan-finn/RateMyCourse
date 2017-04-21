//
//  SecondViewController.swift
//  Skeleton
//
//  Created by student4342 on 4/9/17.
//  Copyright © 2017 JohnGarza. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

  
    @IBOutlet weak var signInButton: UIBarButtonItem!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var schoolYearMajorLabel: UILabel!
    @IBAction func favoritesButton(_ sender: UIButton) {
    }
    
    @IBAction func friendsButton(_ sender: UIButton) {
    }
    
    @IBAction func settingsButton(_ sender: UIButton) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signInSignOut(_ sender: UIBarButtonItem) {
        if sender.title == "Sign In"{
            self.performSegue(withIdentifier: "toSignInView", sender: self)
        }
        else {
            UserDefaults.standard.set(false, forKey: "rmcSignedIn")
            UserDefaults.standard.removeObject(forKey: "rmcUsername")
            self.navigationItem.rightBarButtonItem?.title = "Sign In"
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let userIsSignedIn = UserDefaults.standard.bool(forKey: "rmcSignedIn")
        guard UserDefaults.standard.string(forKey: "rmcUsername") != nil else {return}
        
        if (userIsSignedIn){
            self.navigationItem.rightBarButtonItem?.title = "Sign Out"
            
        }
    
    }


}

