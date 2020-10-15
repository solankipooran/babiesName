//
//  Models.swift
//  HinduBabyName
//
//  Created by POORAN SUTHAR on 04/06/20.
//  Copyright © 2020 POORAN SUTHAR. All rights reserved.
//

import Foundation

enum Gender: Int{
    case female = 0
    case male = 1
}

class BabiesName: Decodable {
    let name: String
    let meaning: String
    var isFavorite: Bool!
    
    init(name: String, meaning: String) {
        self.name = name
        self.meaning = meaning
        self.isFavorite = false
    }
}

struct AlphabaticFilter {
    var alphabate: String
    var isSelected = false
}
