//
//  EventViewController.swift
//  Studor
//
//  Created by James Ahrens on 3/14/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventOwnerLabel: UILabel!
    @IBOutlet weak var editEventButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: Hide edit event button if user is not owner of event
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let child = segue.destination as! EditEventViewController
        child.eventID = "" // TODO: Get the eventID
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
