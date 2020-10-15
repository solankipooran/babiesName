//
//  ChildNameViewController.swift
//  HinduBabyName
//
//  Created by POORAN SUTHAR on 28/05/20.
//  Copyright © 2020 POORAN SUTHAR. All rights reserved.
//

import UIKit
import CoreData

class NamesViewController: UIViewController {
    
    var searchBar = UISearchBar()
    var beginFilter: [String] = []
    var alphabaticArray = [AlphabaticFilter]()
    var maleBabyName : [BabiesName] = []
    var femaleBabyName : [BabiesName] = []
    var babyName: [BabiesName] = []
    let alphabate = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    struct Constants {
        static let babyPinkColor = UIColor(displayP3Red: 255/255.0 , green: 90/255.0 , blue: 95/255.0, alpha: 1)
        static let blueColor = UIColor(displayP3Red: 0/255.0, green: 166/255.0, blue: 153/255.0, alpha: 1)
    }
    var wholeBabyNames: [BabiesName] = []
    var filteredBabyNames: [BabiesName] = []
    var searchedBabyNames: [BabiesName] = []
    var isSearchOn = false
    var gender: Gender = .female
    var favoriteNames: [String] = []
    
    @IBOutlet weak var genderSegmentController: UISegmentedControl!
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var namesTableView: UITableView!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        namesTableView.keyboardDismissMode = .onDrag
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        for i in 0..<26 {
            alphabaticArray.append(AlphabaticFilter(alphabate: alphabate[i], isSelected: false) )
        }
        addSearchBarButton()
        addSearchBar()
        jsonDecodation()
        valueFilterByGender(gender: gender)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateValues()
        dataFetching()
        namesTableView.reloadData()
    }
    
    func updateValues(){
        genderSegmentController.selectedSegmentIndex = gender == Gender.female ?
            0 : 1
        genderSegmentController.selectedSegmentTintColor = gender == Gender.female ?
            Constants.babyPinkColor : Constants.blueColor
        self.navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.tintColor = gender == Gender.female ?
            Constants.babyPinkColor : Constants.blueColor
        navigationController?.navigationBar.tintColor = gender == Gender.female ?
            Constants.babyPinkColor : Constants.blueColor
    }
    
    func dataFetching() {
        if  let data = CoredataManager.fetchdata() as? [NSManagedObject]{
            let name = data.map{ $0.value(forKey: "name") } as? [String]
            favoriteNames = name ?? []
        }
    }
    
    @objc func keyboardHide() {
        searchBar.isHidden = true
    }
    
    func addSearchBar() {
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.isHidden = true
        searchBar.showsCancelButton = false
        searchBar.returnKeyType = .default
        searchBar.placeholder = "Search Name"
    }
    
    func addSearchBarButton() {
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(serachButtonPressed))
        navigationItem.rightBarButtonItem = searchButton
    }
    
    @objc func serachButtonPressed() {
        searchBar.isHidden = !searchBar.isHidden
        if searchBar.isHidden {
            searchBar.resignFirstResponder()
        } else {
            searchBar.becomeFirstResponder()
        }
    }
    
    @IBAction func filterButtonActiom(_ sender: Any) {
        if genderView.isHidden == false {
            genderView.isHidden = true
        } else {
            genderView.isHidden = false
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func genderSegmentControllerAction(_ sender: Any) {
        switch (genderSegmentController.selectedSegmentIndex) {
        case Gender.female.rawValue:
            genderSegmentController.selectedSegmentTintColor = Constants.babyPinkColor
            gender = .female
            updateValues()
            valueFilterByGender(gender: .female)
        case Gender.male.rawValue:
            genderSegmentController.selectedSegmentTintColor = Constants.blueColor
            gender = .male
            updateValues()
            valueFilterByGender(gender: .male)
        default:
            print("Error")
        }
    }
    func jsonDecodation() {
        for index in 0..<4 {
            let char = alphabate[index]
            let female = fetchJson(for: "\(char)F")
            femaleBabyName.append(contentsOf: female)
            
            let male =  fetchJson(for: "\(char)M")
            maleBabyName.append(contentsOf: male)
        }
    }
    
    func fetchJson(for fileName: String) -> [BabiesName] {
        do {
            let path = Bundle.main.url(forResource: fileName, withExtension: "json")
            let data = try Data(contentsOf: path!)
            let decoder = JSONDecoder()
            var value = try decoder.decode([BabiesName].self, from: data)
            value = value.map({ name -> BabiesName in
                name.isFavorite = false
                return name
            })
            return value
            
        } catch {
            print("*** \(error.localizedDescription)")
        }
        return []
    }
    
    
    func valueFilterByGender(gender : Gender){
        babyName = gender == Gender.male ? maleBabyName : femaleBabyName
        filteredBabyNames = babyName
        namesTableView.reloadData()
    }
}

extension NamesViewController : UITableViewDataSource ,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchOn {
            return searchedBabyNames.count
        } else {
            return filteredBabyNames.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NamesTableViewCell", for: indexPath) as? NamesTableViewCell  else {
            return UITableViewCell()
        }
        let filterbaby = isSearchOn ? searchedBabyNames : filteredBabyNames
        let baby = filterbaby[indexPath.row]
        cell.addFavoriteButton.addTarget(self, action: #selector(addToFav), for: .touchUpInside)
        cell.addFavoriteButton.setImage(UIImage(named: favoriteNames.contains(baby.name) ? "fav" : "unfav"), for: .normal)
        cell.addFavoriteButton.tag = indexPath.row
        cell.babyNameLabel.text = baby.name
        cell.meaningLabel.text = baby.meaning
        return cell
    }
    
    @objc func addToFav(_ button: UIButton) {
        let filterbaby = isSearchOn ? searchedBabyNames : filteredBabyNames
        let baby = filterbaby[button.tag]
        let dictionary = ["name" : baby.name  , "meaning" : baby.meaning]
        if favoriteNames.contains(baby.name) {
            CoredataManager.deleteData(baby: baby)
            favoriteNames.removeAll(where: { $0 == baby.name })
        } else {
            CoredataManager.saveData(dictionary: dictionary)
            favoriteNames.append(baby.name)
        }
        let indexPath = IndexPath(row: button.tag, section: 0)
        namesTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailedVC = storyBoard.instantiateViewController(identifier: "DetailsViewController") as? DetailsViewController else {
            return
        }
        let filterbaby = isSearchOn ? searchedBabyNames : filteredBabyNames
        let tappedName = filterbaby[indexPath.row].name
        let subString = tappedName.prefix(4)
        let suggestionName = babyName.filter{$0.name.lowercased().hasPrefix(subString.lowercased())}
        detailedVC.suggestionNames = suggestionName
        detailedVC.gender = gender
        detailedVC.babyDetails = filterbaby[indexPath.row]
        self.navigationController?.pushViewController(detailedVC, animated: true)
    }
}

extension NamesViewController :  UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return alphabaticArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlphabateCollectionViewCell", for: indexPath) as? AlphabateCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 20
        cell.alphabateLabel.text = alphabaticArray[indexPath.row].alphabate
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let letter = alphabaticArray[indexPath.row].alphabate
        alphabaticArray[indexPath.row].isSelected = !alphabaticArray[indexPath.row].isSelected
        
        if alphabaticArray[indexPath.row].isSelected == true {
            cell?.backgroundColor = gender == Gender.female ? Constants.babyPinkColor : Constants.blueColor
            cell?.layer.borderWidth = 1
        } else {
            cell?.backgroundColor = UIColor.white
            cell?.layer.borderWidth = 1
        }
        
        if beginFilter.contains(letter) {
            beginFilter.removeAll(where: { $0 == letter })
        } else {
            beginFilter.append(letter)
        }
        if beginFilter.isEmpty {
            filteredBabyNames = babyName
        } else {
            let filterdValues = babyName.filter({ baby -> Bool in
                var hasPrefix = false
                for filter in beginFilter {
                    if baby.name.hasPrefix(filter) {
                        hasPrefix = true
                        break
                    }
                }
                return hasPrefix
            })
            filteredBabyNames = filterdValues
        }
        namesTableView.reloadData()
    }
}

extension NamesViewController :  UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            isSearchOn = false
            namesTableView.reloadData()
        } else {
            isSearchOn = true
        }
        let filteredArray = babyName.filter{$0.name.lowercased().hasPrefix(searchText.lowercased())}
        searchedBabyNames = filteredArray
        namesTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        filterCollectionView.isHidden = true
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        view.endEditing(true)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        filterCollectionView.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        return true
    }
}
