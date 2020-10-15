//
//  FavoriteNameViewController.swift
//  HinduBabyName
//
//  Created by POORAN SUTHAR on 02/06/20.
//  Copyright © 2020 POORAN SUTHAR. All rights reserved.
//

import UIKit
import CoreData

class FavoriteNameViewController: UIViewController {
    
    var favoriteNames: [NSManagedObject] = []
    @IBOutlet weak var favTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let data = CoredataManager.fetchdata()
        favoriteNames = data as! [NSManagedObject]        
        favTable.reloadData()
    }
}

extension FavoriteNameViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell  = tableView.dequeueReusableCell(withIdentifier: "FavoriteNameTableViewCell", for: indexPath) as? FavoriteNameTableViewCell else {
            return UITableViewCell()
        }
        cell.favoriteButton.addTarget(self, action: #selector(removeToFav), for: .touchUpInside)
        cell.favoriteButton.tag = indexPath.row
        cell.nameLabel.text = favoriteNames[indexPath.row].value(forKey: "name") as? String
        cell.meaningLabel.text = favoriteNames[indexPath.row].value(forKey: "meaning") as? String
        return cell
    }
    
    @objc func removeToFav(_ button: UIButton) {
        let baby = favoriteNames[button.tag]
        let babyName = BabiesName(name: baby.value(forKey: "name") as? String ?? "" ,
                                  meaning: baby.value(forKey: "meaning") as? String ?? "")
        CoredataManager.deleteData(baby: babyName)
        favoriteNames.remove(at: button.tag)
        let indexPath = IndexPath(row: button.tag, section: 0)
        favTable.performBatchUpdates({
            favTable.deleteRows(at: [indexPath] , with: .automatic)
        }) { _ in
            self.favTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailsVC = storyBoard.instantiateViewController(identifier: "DetailsViewController") as? DetailsViewController else {
            return
        }
        let baby = favoriteNames[indexPath.row]
        let babyNameDetails = BabiesName(name: baby.value(forKey: "name") as? String ?? "",
                                         meaning: baby.value(forKey: "meaning") as! String ?? "")
        detailsVC.buttonHide = true
      //  detailsVC.babyDetails = babyNameDetails
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
