//
//  FavoriteNameTableViewCell.swift
//  HinduBabyName
//
//  Created by POORAN SUTHAR on 02/06/20.
//  Copyright © 2020 POORAN SUTHAR. All rights reserved.
//

import UIKit
import Lottie

class FavoriteNameTableViewCell: UITableViewCell {

    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var meaningLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.cornerRadius = 5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        // Configure the view for the selected state
    }
}
