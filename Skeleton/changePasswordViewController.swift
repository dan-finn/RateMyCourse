//
//  changePasswordViewController.swift
//  Skeleton
//
//  Created by Dan Finn on 4/23/17.
//  Copyright © 2017 JohnGarza. All rights reserved.
//

import UIKit
import CryptoSwift

class changePasswordViewController: UIViewController {

    var curUser = User()
    let dbAccessor = DBManager(poolID: "us-east-1:63f21831-90a5-433e-bcee-4ece294731bd")

    @IBOutlet weak var curPasswordField: UITextField!
    @IBOutlet weak var newPassField: UITextField!
    @IBOutlet weak var confPassField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let fetchUser = dbAccessor.getUser(Username: UserDefaults.standard.string(forKey: "rmcUsername")!) else {dismiss(animated: true, completion: nil); return}
        curUser = fetchUser
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissView(){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changePassword(){
        
        if (curPasswordField.text == "" || newPassField.text == "" || confPassField.text == ""){
            return
        }
        
        let curPassHash = hashPassword(password: curPasswordField.text!)
        
        if (curPassHash != curUser?.passwordHash){
            let alertController = UIAlertController(title: "ERROR", message: "Current password is incorrect", preferredStyle: .alert)
            let confAction = UIAlertAction(title: "OKAY", style: .default, handler: nil)
            alertController.addAction(confAction)
            present(alertController, animated: true, completion: nil)
            return
            
        }
        
        if (newPassField.text != confPassField.text){
                let alertController = UIAlertController(title: "ERROR", message: "New Passwords Do Not Match", preferredStyle: .alert)
                let confAction = UIAlertAction(title: "OKAY", style: .default, handler: nil)
                alertController.addAction(confAction)
                present(alertController, animated: true, completion: nil)
                return

        }
        
        let mapper = dbAccessor.getMapperObject()
        mapper.remove(curUser!)
        
        curUser?.passwordHash = hashPassword(password: newPassField.text!)
        
        _ = dbAccessor.addUser(user: curUser!)
        
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
