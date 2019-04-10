//
//  EventViewController.swift
//  Studor
//
//  Created by James Ahrens on 3/14/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventOwnerLabel: UILabel!
    @IBOutlet weak var editEventButton: UIButton!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var participantsTextView: UITextView!
    
    var selectedEvent: Event?
    var timeOfEvent: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSelectedEventElements()
    }
    
    func setSelectedEventElements(){
        self.title! = selectedEvent!.title!
        eventOwnerLabel.text = "Creator: " + selectedEvent!.creator!
        eventLocationLabel.text = selectedEvent!.loc!
        eventDateLabel.text = timeOfEvent!
        
        participantsTextView.text! += "\n"
        
        for p in selectedEvent!.participants! {
            participantsTextView.text! += p + "  \n"
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! EditEventViewController
        dest.editedEvent = selectedEvent!
    }
}
