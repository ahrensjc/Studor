//
//  EditEventViewController.swift
//  Studor
//
//  Created by James Ahrens on 3/15/19.
//  Copyright © 2019 James Ahrens. All rights reserved.

import UIKit
import Firebase

class EditEventViewController: UIViewController {
    
    var editedEvent: Event?

    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventDatePicker: UIDatePicker!
    @IBOutlet weak var eventLocationTextField: UITextField!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        
        var changeTitle = false
        var changeDate = false
        var changeLocation = false
        
        if let newTitle = eventNameTextField.text {
            changeTitle = (newTitle != editedEvent!.title!)
        }
        
        if let newLocation = eventLocationTextField.text {
            changeLocation = (newLocation != editedEvent!.loc!)
        }
        
        changeDate = (editedEvent!.date! != eventDatePicker.date)
        
        
        if changeDate || changeTitle || changeLocation {
            
            let batch = db.batch()
            
            // Update the event data
            let eventRef = db.collection("Events").document(editedEvent!.eventId!)
            
            
            if changeTitle {
                batch.updateData(["title": eventNameTextField.text! ], forDocument: eventRef)
            }
            
            if changeLocation {
                batch.updateData(["location": eventLocationTextField.text! ], forDocument: eventRef)
            }
            
            if changeDate {
                batch.updateData(["date": eventDatePicker.date ], forDocument: eventRef)
            }
            
            // Commit the batch
            batch.commit() { err in
                if let err = err {
                    print("Error writing event edit \(err)")
                } else {
                    print("Event edit succeeded.")
                }
            }
        }
        self.dismiss(animated: false, completion: nil)
    }
}
