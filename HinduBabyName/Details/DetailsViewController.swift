//
//  DetailsViewController.swift
//  HinduBabyName
//
//  Created by POORAN SUTHAR on 30/05/20.
//  Copyright © 2020 POORAN SUTHAR. All rights reserved.
//

import UIKit



class DetailsViewController: UIViewController  {
    
    var babyDetails : BabiesName!
    var suggestionNames : [BabiesName] = []
    var buttonHide = false
    var gender: Gender = .female
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var meaningLabel: UILabel!
    @IBOutlet weak var similarName: UIButton!
   
    @IBOutlet weak var genderImage: UIImageView!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var meaningView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if buttonHide == true {
            similarName.isHidden = true
            numberLabel.isHidden = true
        }else{
            similarName.isHidden = false
        }
        nameView.layer.cornerRadius = 12
        meaningView.layer.cornerRadius = 12
        similarName.layer.cornerRadius = 12
        genderImage.image = gender == Gender.female ? UIImage(named: "Female") : UIImage(named: "Male")
//        if babyDetails.gender == "M" {
//            femaleGenderImage.isHidden = true
//        } else if babyDetails.gender == "F" {
//            maleGenderImage.isHidden = true
//        }
        namelabel.text = babyDetails.name
        meaningLabel.text = babyDetails.meaning
        numberLabel.text = "\(suggestionNames.count)"
    }
    
    @IBAction func similarNameButtonAction(_ sender: Any) {
        
    }
}
