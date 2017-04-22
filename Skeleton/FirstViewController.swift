//
//  FirstViewController.swift
//  Skeleton
//
//  Created by student4342 on 4/9/17.
//  Copyright © 2017 JohnGarza. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var schoolTextField: UITextField!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var schoolPicker: UIPickerView!
    @IBOutlet weak var departmentPicker: UIPickerView!
    
    @IBOutlet weak var deptTextField: UITextField!
    var testPicker: UIPickerView! = UIPickerView()
    
    var schoolPickerData = ["All", "ArtSci","Engineering","Olin"]
    
    var allData = ["Select a School", "All"]
    var artSciData = ["Art class", "Science class"]
    var engineeringData: [String] = []
    var olinData = ["Accounting", "Finance"]
    var departmentPickerData: [String] = []
    let mapper = courseToDeptMapper()
    
    @IBAction func searchButton(_ sender: UIButton) {
        let resultsViewController = ResultsView()
        self.navigationController?.pushViewController(resultsViewController, animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        engineeringData = mapper.engineeringDeptNameArray
        self.departmentPickerData = allData
        schoolPicker.dataSource = self
        schoolPicker.delegate = self
        departmentPicker.dataSource = self
        departmentPicker.delegate = self
        self.schoolTextField.delegate = self
        self.schoolTextField.inputView = testPicker
        self.deptTextField.delegate = self
        self.deptTextField.inputView = testPicker
        testPicker.isHidden = true
        schoolPicker.isHidden = true
        departmentPicker.isHidden = true
        schoolTextField.text = schoolPickerData[0]
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(singleTap)

        
        
    }
    
    func dismissKeyboard(){
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == schoolPicker {
            return schoolPickerData.count
        } else if pickerView == departmentPicker {
            return departmentPickerData.count
        } else if pickerView == testPicker {
            return schoolPickerData.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == schoolPicker {
            return schoolPickerData[row]
        } else if pickerView == departmentPicker {
            return departmentPickerData[row]
        } else if pickerView == testPicker {
            return schoolPickerData[row]
        }
        return ""
    }
    
    // depreciated
    @IBAction func updateLabel(_ sender: UIButton) {
        let searchText = self.searchBar.text
        self.testLabel.text = searchText
        
        /*
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
        
        if let fetchedCourses = self.dbAccessor.scanCourses(query: searchText!, filter: .title) {
            for course in fetchedCourses {
                print(course.Title)
            }
        }
            }*/
    }
    
        
    
    
    //http:
    //stackoverflow.com/questions/31132807/how-can-i-populate-a-picker-view-depending-on-the-selection-of-another-picker-vi
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == schoolPicker {
            switch row {
            case 0:
                departmentPickerData = allData
            case 1:
                departmentPickerData = artSciData
            case 2:
                departmentPickerData = engineeringData
            case 3:
                departmentPickerData = olinData
            default:
                departmentPickerData = artSciData
            }
        }
            if pickerView == schoolPicker {
                self.schoolTextField.text = schoolPickerData[row]
                self.schoolPicker.isHidden = true
            }
            if pickerView == departmentPicker {
                
                self.deptTextField.text = departmentPickerData[row]
                self.departmentPicker.isHidden = true
                
            }
            // IMPORTANT reload the data on the item picker
        departmentPicker.reloadAllComponents()
        
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if(textField == self.view.viewWithTag(1) as! UITextField) {
        departmentPicker.isHidden = true
        schoolPicker.isHidden = false
        }
        
        if (textField == self.view.viewWithTag(2) as! UITextField){
            schoolPicker.isHidden = true
            departmentPicker.isHidden = false
        }
        
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSearchResultsView" {
            print("Transitioning to searchResultsView")
            let searchText = self.searchBar.text
            let destVC = segue.destination as! ResultsView
            destVC.querySent = searchText!
            switch(self.schoolTextField.text!){
            case "All" :
                destVC.focuserSent = ""
                break
            case "ArtSci":
                destVC.focuserSent = "L"
                break
            case "Engineering":
                destVC.focuserSent = "E"
                break
            case "Olin":
                destVC.focuserSent = "B"
                break
            default:
                break
            
            }
            
            if (self.deptTextField.text != "ALL" && self.deptTextField.text != "Select a School" && self.deptTextField.text != ""){
                destVC.focuserSent = mapper.getCodeFromDeptName(name: self.deptTextField.text!)
            }
            
            
        }
    }


}

