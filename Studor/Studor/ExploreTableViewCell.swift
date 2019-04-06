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
        self.type.layer.borderWidth = 0.875; //this is the width of the border of nickname om profile page
        self.type.layer.cornerRadius = 8; //rounded edges
        self.type.layer.borderColor = UIColor(red:137/250, green:17/250, blue:0/250, alpha: 1).cgColor //the color of the border
        
    }
}
