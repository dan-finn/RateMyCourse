//
//  ReviewsView.swift
//  Skeleton
//
//  Created by Dan Finn on 4/20/17.
//  Copyright © 2017 JohnGarza. All rights reserved.
//

import UIKit

class ReviewsView: UIViewController, UICollectionViewDataSource {
    
    let DISPLAY_VIEW_TAG = 1
    let OVERALL_LABEL_TAG = 2
    let PROFESSOR_LABEL_TAG = 3
    let COMMENTS_LABEL_TAG = 4
    let HIDDEN_CODE_LABEL_TAG = 5
    
    var reviews: [Review] = []
    var incomingCourseCode = ""
    
    
    @IBOutlet weak var noReviewsLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    let dbAccessor = DBManager(poolID: "us-east-1:63f21831-90a5-433e-bcee-4ece294731bd")
    var searchResults = [Review]()
    var hasLoaded = false
    @IBOutlet weak var theCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noReviewsLabel.isHidden = true
        self.theCollectionView.isHidden = true
        self.theCollectionView.dataSource = self
        spinner.startAnimating()
    
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout();
        
        layout.sectionInset = UIEdgeInsets(top: 10, left: 30, bottom: 0, right: 30)
        
        layout.itemSize = CGSize(width: 308, height: 88)
        
        theCollectionView.collectionViewLayout = layout
        self.theCollectionView.reloadData()
        

        
        print("scanning for reviews with code \(incomingCourseCode)")
        // Do any additional setup after loading the view.
    }
    
    func getResults(){
        print("Scanning with query \(self.incomingCourseCode) ")
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async{
            if let fetchedResults = self.dbAccessor.scanReviews(code: self.incomingCourseCode){
                for review in fetchedResults {
                   self.reviews.append(review)
                    self.theCollectionView.reloadData()
                    
                }
                
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    self.spinner.isHidden = true
                    
                    if (self.reviews.count <= 0){
                        self.noReviewsLabel.isHidden = false
                    } else {
                    self.theCollectionView.isHidden = false
                   self.theCollectionView.reloadData()
                    }
                    
                }
                
                
            }
        }

    
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewCardCell", for: indexPath)
        
        let review = reviews[indexPath.row]
        
        let overallDisplayView = cell.viewWithTag(DISPLAY_VIEW_TAG) as! DisplayView
        let overallLabel = cell.viewWithTag(OVERALL_LABEL_TAG) as! UILabel
        let overallAsFloat = CGFloat(Double(review.overall) / 10.0)
        
        let professorLabel = cell.viewWithTag(PROFESSOR_LABEL_TAG) as! UILabel
        professorLabel.text = "Professor: \(review.professors)"
        
        let commentsLabel = cell.viewWithTag(COMMENTS_LABEL_TAG) as! UILabel
        
        if (review.comments != "Insert comments... (optional)"){
        commentsLabel.text = review.comments
        } else {
            commentsLabel.text = "No comments provided"
        }
        
        let hiddenCodeLabel = cell.viewWithTag(HIDDEN_CODE_LABEL_TAG) as! UILabel
        hiddenCodeLabel.text = "\(review.Code)|\(review.user_id)"
        
        overallLabel.text = String(review.overall)
        overallDisplayView.color = getColorFromValue(value: review.overall)
        overallDisplayView.value = overallAsFloat
        
        cell.backgroundColor = UIColor(hue: 0.5611, saturation: 0.33, brightness: 0.96, alpha: 1.0)
        
        cell.contentView.layer.borderColor = UIColor.black.cgColor
        cell.contentView.layer.borderWidth = 3
        cell.contentView.layer.cornerRadius = 2
        
        return cell
    }
    
    func getColorFromValue(value: Int) -> UIColor {
        if (value < 4){
            return UIColor.red
        }
        
        if (value < 7){
            return UIColor.yellow
        }
        
        return UIColor.green
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (self.reviews.count == 0 || hasLoaded == true){
            reviews = []
            getResults()
        }
        theCollectionView.reloadData()
        hasLoaded = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toReviewDetailView" {
            let sendingCell = sender as! UICollectionViewCell
            let destVC = segue.destination as! reviewDetailViewController
            
            let hiddenLabel = sendingCell.viewWithTag(HIDDEN_CODE_LABEL_TAG) as! UILabel
            
            destVC.incomingData = hiddenLabel.text!
            
            
        }
    }
    
    
    

}
