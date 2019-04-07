//
//  EventCreatorViewController.swift
//  Studor
//
//  Created by James Ahrens on 3/14/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import UIKit
import Firebase
import iOSDropDown

class EventCreatorViewController: UIViewController {

    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventDatePicker: UIDatePicker!
    @IBOutlet weak var eventLocationTextField: UITextField!
    @IBOutlet weak var addParticipantButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        addParticipantsDropDown.listHeight = 120
        addParticipantsDropDown.selectedRowColor = UIColor.white
    }
    @IBOutlet weak var addParticipantsDropDown: DropDown!
    
    var participants: [String] = []
    
    @IBAction func addParticipantsButton(_ sender: Any) {

    }
    
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        if let title = eventNameTextField.text, let loc = eventLocationTextField.text{
            
            // TODO: Get the firebase IDs of participants added, have autofill for them, and add the event reference to their document on firestore
            firebaseSingleton.createEvent(users: participants, date: eventDatePicker.date, title: title)
        }
        else{
            self.showMessagePrompt(withString: "Please fill in all form fields.", title: "Missing Fields")
        }
        performSegue(withIdentifier: "unwindToSchedule", sender: self)
    }
    
    func showMessagePrompt(withString: String, title: String) {
        let alert = UIAlertController(title: title, message: withString, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func goBackToScheduleTableVC(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToSchedule", sender: self)
    }
}
