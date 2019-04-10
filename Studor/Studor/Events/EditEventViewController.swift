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
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        
        var changeTitle = false
        var changeLocation = false
        
        if let newTitle = eventNameTextField.text {
            changeTitle = (newTitle != editedEvent!.title!)
        }
        
        if let newLocation = eventLocationTextField.text {
            changeLocation = (newLocation != editedEvent!.loc!)
        }
        
        
        if changeTitle || changeLocation {
            
            let batch = db.batch()
            
            // Update the event data
            let eventRef = db.collection("Events").document(editedEvent!.eventId!)
            
            
            if changeTitle {
                batch.updateData([ "title": eventNameTextField.text! ], forDocument: eventRef)
            }
            
            if changeLocation {
                batch.updateData([ "location": eventLocationTextField.text! ], forDocument: eventRef)
            }
            
            
            batch.updateData([ "date": eventDatePicker.date ], forDocument: eventRef)
            
            
            // Commit the batch
            batch.commit() { err in
                if let err = err {
                    print("Error writing event edit \(err)")
                } else {
                    print("Event edit succeeded.")
                }
            }
        }
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
