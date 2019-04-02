//
//  CreateGroupViewController.swift
//  Studor
//
//  Created by James Ahrens on 3/14/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import UIKit
import SendBirdSDK

class CreateGroupViewController: UIViewController {
    
    @IBOutlet weak var groupNameTextField: UITextField!
    
    @IBOutlet weak var addParticipantsTextField: UITextField!
    
    @IBOutlet weak var participantsTextView: UITextView!
    
    var groupName: String!
    var participants: [String]! // should have userID's, may also want to make this a tuple and contain nickname as well
    var sendbirdID : String!
    var nickname : String!
    var sendbirdUser : SBDUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        participants = [String]()
        participants.append(sendbirdID) // TODO:
        participantsTextView.text = sendbirdID
    }
    
    @IBAction func addParticipantButtonTapped(_ sender: Any) {
        if(addParticipantsTextField.text != "" || addParticipantsTextField != nil) {
            participants.append(addParticipantsTextField.text!)
            participantsTextView.text.append(", " + addParticipantsTextField.text!)
            addParticipantsTextField.text = ""
        }
    }
    
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        if groupNameTextField.text == "" || groupNameTextField.text == nil {
            // TODO: display error saying group name cannot be empty
        } else if participants.count == 1 {
            // TODO: display error saying group cannot be just you
        } else {
            var params = SBDGroupChannelParams()
            params.isPublic = false
            params.isEphemeral = false
            params.isDistinct = false
            params.addUserIds(participants)
            params.operatorUserIds = ["rando1"]
            params.name = self.groupNameTextField.text!
            //params.coverImage = FILE
            //params.coverUrl = "COVER_URL"
            //params.data = "DATA"
            //params.customType = "CUSTOM_TYPE"
            
            SBDGroupChannel.createChannel(with: params) { (channel, error) in
                guard error == nil else {   // Error.
                    return
                }

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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    
    */

}
