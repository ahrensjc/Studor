//
//  CreateGroupViewController.swift
//  Studor
//
//  Created by James Ahrens on 3/14/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import UIKit
import SendBirdSDK
import iOSDropDown

class CreateGroupViewController: UIViewController {
    
    @IBOutlet weak var groupNameTextField: UITextField!
    
    @IBOutlet weak var addParticipantsDropDown: DropDown!
    
    //@IBOutlet weak var addParticipantsTextField: UITextField!
    
    @IBOutlet weak var participantsTextView: UITextView!
    
    var groupName: String!
    var participants: [String]! // should have userID's, may also want to make this a tuple and contain nickname as well
    var sendbirdID : String!
    var nickname : String!
    var sendbirdUser : SBDUser!
    var usersList : [SBDUser]!
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let applicationUserListQuery = SBDMain.createApplicationUserListQuery()
        //applicationUserListQuery?.userIdsFilter = ["jim"]
        applicationUserListQuery?.limit = 100
        applicationUserListQuery?.loadNextPage(completionHandler: { (users, error) in
            guard error == nil else {
                print("error getting user list")
                print(error as Any)
                return
            }
            self.usersList = users!
            var usernames = [String]()
            for user in users! {
                usernames.append(user.userId)
            }
            self.addParticipantsDropDown.optionArray = usernames
        })

        addParticipantsDropDown.listHeight = 120
        addParticipantsDropDown.selectedRowColor = UIColor.white
        participants = [String]()
        participants.append(sendbirdID) // TODO:
        participantsTextView.text = sendbirdID
    }
    
    @IBAction func addParticipantButtonTapped(_ sender: Any) {
        if(addParticipantsDropDown.text != "" || addParticipantsDropDown != nil) {
            participants.append(addParticipantsDropDown.text!)
            participantsTextView.text.append(", " + addParticipantsDropDown.text!)
            addParticipantsDropDown.text = ""
        }
        
    }
    
    
    
    
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        if groupNameTextField.text == "" || groupNameTextField.text == nil {
            // TODO: display error saying group name cannot be empty
            self.showMessagePrompt(withString: "Group name cannot be empty.", title: "Error")
        } else if participants.count == 1 {
            self.showMessagePrompt(withString: "Groups must have at least 2 users.", title: "Error")
        } else {
            var params = SBDGroupChannelParams()
            params.isPublic = true
            params.isEphemeral = false
            params.isDistinct = false
            params.addUserIds(participants)
            params.operatorUserIds = ["rando1"]
            params.name = self.groupNameTextField.text!
            
            SBDGroupChannel.createChannel(with: params) { (channel, error) in
                guard error == nil else {   // Error.
                    return
                }
                
                firebaseSingleton.createGroup(channelName: channel!.name, sendbirdUrl: channel!.channelUrl)

                var newMetaData = [self.sendbirdID : "accepted"]
                for participant in self.participants {
                    newMetaData[participant] = "invited"
                }
                newMetaData[self.sendbirdID] = "accepted"
                
                channel?.createMetaData((newMetaData as? [String : String])!, completionHandler: { (metaData, error) in
                    guard error == nil else {   // Error.
                        print("error adding channel metadata")
                        print(error as Any)
                        return
                    }
                })
            }
            
            
            self.navigationController?.popViewController(animated: true)
            //self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)
    }
    
    func showMessagePrompt(withString: String, title: String) {
        let alert = UIAlertController(title: title, message: withString, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    
    */

}
