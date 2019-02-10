//
//  ExploreTableViewCell.swift
//  Studor
//
//  Created by James Ahrens on 2/2/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import UIKit

class ExploreTableViewCell: UITableViewCell {
    
    var thing = 0

    @IBOutlet weak var connect: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var type: UILabel!
    
    @IBOutlet weak var rate: UILabel!
    
    var nameText : String!
    
    var typeText : String!
    
    var rateText : String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //initialiseData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func initialiseData(){
        name!.text! = nameText
        type!.text! = typeText
        rate!.text! = rateText
    }
}
