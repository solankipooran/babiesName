//
//  GenderViewController.swift
//  HinduBabyName
//
//  Created by POORAN SUTHAR on 28/05/20.
//  Copyright © 2020 POORAN SUTHAR. All rights reserved.
//

import UIKit
import Lottie

class GenderViewController: UIViewController {
    
    @IBOutlet weak var congratulationView: AnimationView!
    @IBOutlet weak var motherView: AnimationView!
    @IBOutlet weak var babyGirlButton: UIButton!
    @IBOutlet weak var babyBoyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        lottieAnimations()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func lottieAnimations(){
        motherView.animation = Animation.named("MomAndChild")
        congratulationView.animation = Animation.named("Congratulation")
        motherView.play()
        congratulationView.play()
        motherView.loopMode = .loop
    }
    
    @IBAction func babyGirlButtonAction(_ sender: Any) {
        changeVC(genderType: .female)
    }
    
    @IBAction func babyBoyButtonAction(_ sender: Any) {
        changeVC(genderType: .male)
    }
    
    func changeVC(genderType: Gender) {
        guard let tabbar  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TabBar") as? UITabBarController,
            let navigationController = tabbar.viewControllers?.first as? UINavigationController,
            let nameViewController = navigationController.viewControllers.first as? NamesViewController
            else {
                return
        }
        nameViewController.gender = genderType
        tabbar.modalPresentationStyle = .fullScreen
        self.present(tabbar, animated: true, completion: nil)
    }
}

