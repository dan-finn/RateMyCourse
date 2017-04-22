//
//  signInViewController.swift
//  Skeleton
//
//  Created by Dan Finn on 4/21/17.
//  Copyright © 2017 JohnGarza. All rights reserved.
//

import UIKit
import CryptoSwift

class signInViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    let dbAccessor = DBManager(poolID: "us-east-1:63f21831-90a5-433e-bcee-4ece294731bd")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameField.autocorrectionType = .no
        if(UserDefaults.standard.bool(forKey: "rmcSignedIn")){
            self.dismiss(animated: true, completion: nil)
        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func hashPassword(password: String) -> String{
        let enteredPW = password
        let bytes = Array(enteredPW.utf8)
        let data = Data(bytes: bytes)
        let hash = data.md5()
        var convHash = [UInt8](repeating: 0, count: hash.count)
        
        hash.copyBytes(to: &convHash, count: hash.count)
        
        var hashString = ""
        
        for byte in convHash {
            let byteAsInt = Int(byte)
            hashString += String(byteAsInt)
        }
        
        return hashString
    
    }
    
    @IBAction func registerUser(){
        //TODO check if username already is registered
        
        
        guard let newUsername = usernameField.text else {return}
        
        if (newUsername == ""){
            return
        }
        
        if dbAccessor.getUser(Username: newUsername) != nil{
            print("User Found")
            let alertController = UIAlertController(title: "ERROR", message: "Username already registered!", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "OKAY", style: .default, handler: nil)
            
            alertController.addAction(confirmAction)
            present(alertController, animated: true, completion: nil)
            
            passwordField.text = ""
            usernameField.text = ""
            
            return
        }
        
        guard let newPassword = passwordField.text else {return}
        
        if (newUsername == "" || newPassword == ""){
            return
        }
        let passHash = hashPassword(password: newPassword);
        
        let newUser = User()
        newUser?.userID = UUID().uuidString
        newUser?.Username = newUsername
        newUser?.passwordHash = passHash
        
        _ = dbAccessor.addUser(user: newUser!)
        
        let alertController = UIAlertController(title: "SUCCESS", message: "Registered! Please log in.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OKAY", style: .default, handler: nil)
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
        
        passwordField.text = ""
        usernameField.text = ""
        
    }
    
    @IBAction func signInUser(){
        guard let clientUsername = usernameField.text else {return}
        
        if (clientUsername == ""){
            return
        }
        
        if let serverUserObject = dbAccessor.getUser(Username: clientUsername){
            guard let clientPassword = passwordField.text else {return}
            if (clientPassword == ""){
                return
            }
            if (hashPassword(password: clientPassword) == serverUserObject.passwordHash){
                print("SIGN IN SUCCESSFUL")
               
                var isSignedIn = UserDefaults.standard.bool(forKey: "rmcSignedIn")
                isSignedIn = true
                UserDefaults.standard.set(isSignedIn, forKey: "rmcSignedIn")
                UserDefaults.standard.set(serverUserObject.Username, forKey: "rmcUsername")
                UserDefaults.standard.synchronize()
                self.dismiss(animated: true, completion: nil)
                    
            } else {
                let alertController = UIAlertController(title: "ERROR", message: "Incorrect Password", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "OKAY", style: .default, handler: nil)
                
                alertController.addAction(confirmAction)
                self.present(alertController, animated: true, completion: nil)
                passwordField.text = ""
                usernameField.text = ""
            }
            
        }
        else {
            print("user not found")
            return
        }
    
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
