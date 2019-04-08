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
import SendBirdSDK
import UserNotifications

class EventCreatorViewController: UIViewController {

    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventDatePicker: UIDatePicker!
    @IBOutlet weak var eventLocationTextField: UITextField!
    @IBOutlet weak var addParticipantButton: UIButton!
    
    var participants: [String] = []
    var contacts = [String]()
    
    @IBOutlet weak var addParticipantsDropDown: DropDown!
    
    @IBAction func addParticipantsButton(_ sender: Any) {

        let center = UNUserNotificationCenter.current()
        let note = UNMutableNotificationContent()
        let newParticipant = contacts[addParticipantsDropDown.selectedIndex!]
        
        if !participants.contains(newParticipant){
            participants.append(newParticipant)
            note.title = "Notice:"
            note.body = newParticipant + " added to event."
            
            note.categoryIdentifier = "Note"
            note.sound = UNNotificationSound.default
            
            // clear it after adding
            addParticipantsDropDown.text = ""
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
            
            let request = UNNotificationRequest(identifier: "Note", content: note, trigger: trigger)
            
            center.add(request, withCompletionHandler: {
                (error) in
                if error != nil {
                    print("Something went wrong")
                }
                else{
                    print("Notifying user")
                }
            })
        }
        else{
            showMessagePrompt(withString: "User already added to event.", title: "ERR")
        }
        

    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        
        if let title = eventNameTextField.text, let loc = eventLocationTextField.text {
            
            firebaseSingleton.createEvent(users: participants, date: eventDatePicker.date, title: title, location: loc)
            
            participants.removeAll()
        }
        else{
            self.showMessagePrompt(withString: "Please fill in all form fields.", title: "Missing Fields")
        }
        performSegue(withIdentifier: "unwindToSchedule", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addParticipantsDropDown.listHeight = 120
        addParticipantsDropDown.selectedRowColor = UIColor.white
        addParticipantsDropDown.optionArray = contacts
        retrieveSBChannels()
    }
    
    func retrieveSBChannels(){
        let query = SBDGroupChannel.createMyGroupChannelListQuery()
        query?.includeEmptyChannel = false
        
        query?.loadNextPage(completionHandler: { (channels, error) in
            guard error == nil else {
                print(error as Any)
                return
            }

            for channel in channels! {
                for member in channel.members! as! [SBDUser] {
                    
                    if member.userId != firebaseSingleton.getFirestoreIdForCurrentUser(){
                        self.contacts.append(member.userId)
                    }
                }
            }
            
            self.addParticipantsDropDown.optionArray = self.contacts
        })
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
