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
    self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.participantsTextView.layer.borderWidth = 1; //this is the width of the border of nickname om profile page
        self.participantsTextView.layer.cornerRadius = 8; //rounded edges
        self.participantsTextView.layer.borderColor = UIColor(red:137/250, green:17/250, blue:0/250, alpha: 1).cgColor //the color of the border
        
        
        if firebaseSingleton.getFirestoreIdForCurrentUser() != selectedEvent!.creator!{
            editEventButton.isHidden = true
        }
    }
    
    func setSelectedEventElements(){
        self.title! = selectedEvent!.title!
        eventOwnerLabel.text = "Creator: " + selectedEvent!.creator!
        eventLocationLabel.text = selectedEvent!.loc!
        eventDateLabel.text = timeOfEvent!
        
        for p in selectedEvent!.participants! {

            participantsTextView.text! += p + "\n"
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! EditEventViewController
        dest.editedEvent = selectedEvent!
    }
}
