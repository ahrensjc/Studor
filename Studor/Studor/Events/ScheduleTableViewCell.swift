//
//  ScheduleTableViewCell.swift
//  Studor
//
//  Created by James Ahrens on 2/7/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var eventLabel: UILabel!
    
    
        // TODO
        // send filler event data to database
        //
        // for sprint 2:
        // redo this entire part so it isn't on the table
        // go to modal/new page to fill out event info
        // get rid of this function
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
