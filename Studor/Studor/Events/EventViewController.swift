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
    @IBOutlet weak var eventOwnerLabel: UILabel!
    @IBOutlet weak var editEventButton: UIButton!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var participantsLabel: UILabel!
    
    var selectedEvent: Event?
    var timeOfEvent: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSelectedEventElements()
    }
    
    func setSelectedEventElements(){
        eventNameLabel.text = selectedEvent!.title!
        eventOwnerLabel.text = "Created by: " + selectedEvent!.creator!
        eventLocationLabel.text = "Meeting in " + selectedEvent!.loc!
        eventDateLabel.text = "at " + timeOfEvent!
        
        participantsLabel.text! += "\n"
        
        for p in selectedEvent!.participants! {
            print(p)
            participantsLabel.text! += p + "  \n"
        }
        
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
