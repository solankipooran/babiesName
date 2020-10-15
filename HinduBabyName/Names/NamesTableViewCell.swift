//
//  NamesTableViewCell.swift
//  HinduBabyName
//
//  Created by POORAN SUTHAR on 28/05/20.
//  Copyright © 2020 POORAN SUTHAR. All rights reserved.
//

import UIKit
import Lottie

class NamesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addFavoriteButton: UIButton!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var meaningLabel: UILabel!
    @IBOutlet weak var babyNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.cornerRadius = 5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        // Configure the view for the selected state
    }
}
