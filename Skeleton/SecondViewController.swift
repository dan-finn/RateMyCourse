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
    
    @IBOutlet weak var btnStackView: UIStackView!
    @IBOutlet weak var signInLabel: UILabel!
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
            self.btnStackView.isHidden = true
            self.signInLabel.isHidden = false
            self.navigationItem.title = "PROFILE"
            self.tabBarController?.tabBar.items?[1].title = "Profile"
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let userIsSignedIn = UserDefaults.standard.bool(forKey: "rmcSignedIn")
        guard UserDefaults.standard.string(forKey: "rmcUsername") != nil else {return}
        
        if (userIsSignedIn){
            print("here")
            self.navigationItem.rightBarButtonItem?.title = "Sign Out"
            self.btnStackView.isHidden = false
            self.signInLabel.isHidden = true
            self.navigationItem.title = UserDefaults.standard.string(forKey: "rmcUsername")!.capitalized
            self.tabBarController?.tabBar.items?[1].title = UserDefaults.standard.string(forKey: "rmcUsername")!.capitalized
        }
    
    }


}

