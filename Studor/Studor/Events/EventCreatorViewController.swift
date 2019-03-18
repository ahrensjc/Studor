//
//  EventCreatorViewController.swift
//  Studor
//
//  Created by James Ahrens on 3/14/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import UIKit
import Firebase

class EventCreatorViewController: UIViewController {

    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventDatePicker: UIDatePicker!
    @IBOutlet weak var eventLocationTextField: UITextField!
    @IBOutlet weak var eventParticipantTextField: UITextField!
    @IBOutlet weak var addParticipantButton: UIButton!
    @IBOutlet weak var eventDescriptionTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var participants: [String] = []
    
    @IBAction func addParticipantsButton(_ sender: Any) {
        if let participant = eventParticipantTextField.text {
            participants.append(participant)
        }
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        if let title = eventNameTextField.text, let loc = eventLocationTextField.text, let description = eventDescriptionTextView.text{
            firebaseSingleton.createEvent(users: participants, date: eventDatePicker.date, description: description)
        }
        else{
            self.showMessagePrompt(withString: "Please fill in all form fields.", title: "Missing Fields")
        }
    }
    
    func showMessagePrompt(withString: String, title: String) {
        let alert = UIAlertController(title: title, message: withString, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func goBackToMessageKitVC(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToMessageKit", sender: self)
    }
    
    @IBAction func goBackToScheduleTableVC(_ sender: Any) {
        
        performSegue(withIdentifier: "unwindSegueToSchedule", sender: self)
        
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
