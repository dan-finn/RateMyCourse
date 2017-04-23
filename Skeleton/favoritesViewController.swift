//
//  favoritesViewController.swift
//  Skeleton
//
//  Created by Dan Finn on 4/22/17.
//  Copyright © 2017 JohnGarza. All rights reserved.
//

import UIKit

class favoritesViewController: UIViewController, UICollectionViewDataSource {
    
    var courses: [Course] = []
    
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    let dbAccessor = DBManager(poolID: "us-east-1:63f21831-90a5-433e-bcee-4ece294731bd")
    
    @IBOutlet weak var theCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.instructionsLabel.isHidden = true
        
        courses = []
        spinner.startAnimating()
        
        theCollectionView.dataSource = self
        
        guard let curUser = dbAccessor.getUser(Username: UserDefaults.standard.string(forKey: "rmcUsername")!) else {return}
        
        DispatchQueue.global(qos: .background).async {
            
            if let favArray = self.dbAccessor.scanFavoritesForUser(user: curUser) {
                for fav in favArray {
                    if let fetchedCourse = self.dbAccessor.getCourse(courseCode: fav.Code){
                        self.courses.append(fetchedCourse)
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
                if (self.courses.count > 0){
                    self.instructionsLabel.isHidden = true
                    self.theCollectionView.isHidden = false
                }else {
                    self.theCollectionView.isHidden = true
                    self.instructionsLabel.isHidden = false
                }
                self.theCollectionView.reloadData()

            }
            
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath){
        print("selected a cell ")
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.black
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoritesCell", for: indexPath)
        
        let course = courses[indexPath.row]
        
        let titleLabel = cell.viewWithTag(1) as! UILabel
        titleLabel.text = course.Title
        let hiddenCodeLabel = cell.viewWithTag(2) as! UILabel
        hiddenCodeLabel.text = course.Code
        cell.backgroundColor = UIColor(hue: 0.5611, saturation: 0.33, brightness: 0.96, alpha: 1.0)
        
        cell.contentView.layer.borderColor = UIColor.darkGray.cgColor
        cell.contentView.layer.borderWidth = 3
        cell.contentView.layer.cornerRadius = 5
        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCourseDetailView" {
            let sendingCell = sender as! UICollectionViewCell
            sendingCell.backgroundColor = UIColor(hue: 0.6194, saturation: 0.72, brightness: 0.81, alpha: 1.0)
            let destVC = segue.destination as! courseDetailViewController
            let hiddenCodeLabel = sendingCell.viewWithTag(2) as! UILabel
            destVC.incomingCourseCode = hiddenCodeLabel.text!
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        for cell in theCollectionView.visibleCells {
            cell.backgroundColor = UIColor(hue: 0.5611, saturation: 0.33, brightness: 0.96, alpha: 1.0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if (courses.count > 0) {
            print("we're here")
            courses = []
            self.spinner.startAnimating()
            guard let curUser = dbAccessor.getUser(Username: UserDefaults.standard.string(forKey: "rmcUsername")!) else {return}
            
            DispatchQueue.global(qos: .background).async {
                
                if let favArray = self.dbAccessor.scanFavoritesForUser(user: curUser) {
                    for fav in favArray {
                        if let fetchedCourse = self.dbAccessor.getCourse(courseCode: fav.Code){
                            self.courses.append(fetchedCourse)
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    self.spinner.isHidden = true
                    if (self.courses.count > 0){
                        self.instructionsLabel.isHidden = true
                        self.theCollectionView.isHidden = false
                    } else {
                        self.theCollectionView.isHidden = true
                        self.instructionsLabel.isHidden = false
                    }
                    self.theCollectionView.reloadData()
                    

                }
                
            }
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
