//
//  EventViewController.swift
//  Studor
//
//  Created by James Ahrens on 3/14/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import Firebase
import UIKit

class EventViewController: UIViewController {

    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventOwnerLabel: UILabel!
    @IBOutlet weak var editEventButton: UIButton!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var participantsTextView: UITextView!
    
    var selectedEvent: Event?
    var timeOfEvent: String?
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSelectedEventElements()
        
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
    
    func reloadEventDataAfterEdit(id: String, completion: @escaping (Event?, String?) -> Void){
        
        let ref = db.collection("Events").document(id).getDocument{ (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                
                let newDate = Date(timeIntervalSince1970: TimeInterval((document.data()!["date"] as! Timestamp).seconds))
                let newTitle = document.data()!["title"] as! String
                let newLoc = document.data()!["location"] as! String
                
                let editedEvent = Event(date: newDate, title: newTitle, participants: self.selectedEvent!.participants!, eventId: self.selectedEvent!.eventId!, creator: self.selectedEvent!.creator!, loc: newLoc)
                
                completion(editedEvent, nil)
                
            } else {
                print("Could not retrieve event data after edit")
                completion(nil, "Could not retrieve event data after edit")
            }
        }
    }
    
    @IBAction func unwindToEventViewAndReload(segue: UIStoryboardSegue){
        
        print("unwind and reload")
        
        self.reloadEventDataAfterEdit(id: self.selectedEvent!.eventId!) { (editedEvent, error) in
            self.selectedEvent = editedEvent
        }
        self.setSelectedEventElements()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! EditEventViewController
        dest.editedEvent = selectedEvent!
    }
}
