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
    
    @IBOutlet weak var favoritesBtnView: UIView!
    @IBOutlet weak var favoritesBtn: UIButton!
    
    
    @IBOutlet weak var reviewsBtnView: UIView!
    @IBOutlet weak var reviewsBtn: UIButton!
    
    @IBOutlet weak var settingsBtnView: UIView!
    
    @IBOutlet weak var settingsBtn: UIButton!
    
    
    @IBOutlet weak var signInLabel: UILabel!
        override func viewDidLoad() {
        super.viewDidLoad()
        
            favoritesBtnView.layer.backgroundColor = UIColor(hue: 0.5778, saturation: 0.93, brightness: 0.9, alpha: 1.0).cgColor
            reviewsBtnView.layer.backgroundColor = UIColor(hue: 0.5778, saturation: 0.93, brightness: 0.9, alpha: 1.0).cgColor
            settingsBtnView.layer.backgroundColor = UIColor(hue: 0.5778, saturation: 0.93, brightness: 0.9, alpha: 1.0).cgColor
            
            favoritesBtn.setTitleColor(UIColor.white, for: .normal)
            reviewsBtn.setTitleColor(UIColor.white, for: .normal)
            settingsBtn.setTitleColor(UIColor.white, for: .normal)
            
            
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
            
            self.signInLabel.isHidden = false
            self.navigationItem.title = "PROFILE"
            self.tabBarController?.tabBar.items?[1].title = "Profile"
            self.favoritesBtnView.isHidden = true
            self.reviewsBtnView.isHidden = true
            self.settingsBtnView.isHidden = true
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let userIsSignedIn = UserDefaults.standard.bool(forKey: "rmcSignedIn")
        guard UserDefaults.standard.string(forKey: "rmcUsername") != nil else {return}
        
        if (userIsSignedIn){
            print("here")
            self.navigationItem.rightBarButtonItem?.title = "Sign Out"
            self.signInLabel.isHidden = true
            self.navigationItem.title = UserDefaults.standard.string(forKey: "rmcUsername")!.capitalized
            self.tabBarController?.tabBar.items?[1].title = UserDefaults.standard.string(forKey: "rmcUsername")!.capitalized
            
            self.favoritesBtnView.isHidden = false
            self.reviewsBtnView.isHidden = false
            self.settingsBtnView.isHidden = false
        }
    
    }


}

