//
//  ExploreTableViewCell.swift
//  Studor
//
//  Created by James Ahrens on 2/2/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import UIKit

class ExploreTableViewGroupCell: UITableViewCell {
    @IBOutlet weak var channelName: UILabel!
    
    var channelNameText : String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialiseData()
    }
    
    func initialiseData() {
        channelName.text = channelNameText ?? ""
    }
}

class ExploreTableViewUserCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var type: UILabel!
    
    var nameText : String!
    
    var typeText : String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initialiseData()
    }

    func initialiseData() {
        name.text = nameText ?? ""
        type.text = typeText ?? ""
    }
}
