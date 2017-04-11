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
    
    var testPicker: UIPickerView! = UIPickerView()
    
    var schoolPickerData = ["All", "ArtSci","Engineering","Olin","Sam Fox","Brown"]
    
    var artSciData = ["Art class", "Science class"]
    var engineeringData = ["CompSci", "Something lame"]
    var olinData = ["Accounting", "Finance"]
    var samFoxData = ["Painting", "Sculpting"]
    var brownData = ["Psychology", "Sociology"]
    var departmentPickerData: [String] = []
    
    
    @IBAction func searchButton(_ sender: UIButton) {
        let resultsViewController = ResultsView()
        self.navigationController?.pushViewController(resultsViewController, animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        schoolPicker.dataSource = self
        schoolPicker.delegate = self
        departmentPicker.dataSource = self
        departmentPicker.delegate = self
        self.schoolTextField.delegate = self
        self.schoolTextField.inputView = testPicker
        testPicker.isHidden = true
        schoolPicker.isHidden = true
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
        /*if pickerView == schoolPicker {
            switch row {
            case 0:
                departmentPickerData = artSciData
            case 1:
                departmentPickerData = engineeringData
            case 2:
                departmentPickerData = olinData
            case 3:
                departmentPickerData = samFoxData
            case 4:
                departmentPickerData = brownData
            default:
                departmentPickerData = artSciData
            }*/
            if pickerView == schoolPicker {
                self.schoolTextField.text = schoolPickerData[row]
                self.schoolPicker.isHidden = true
            }
            // IMPORTANT reload the data on the item picker
        departmentPicker.reloadAllComponents()
        
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        schoolPicker.isHidden = false
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSearchResultsView" {
            print("Transitioning to searchResultsView")
            let searchText = self.searchBar.text
            let destVC = segue.destination as! ResultsView
            destVC.querySent = searchText!
        }
    }


}

