//
//  CreateGroupViewController.swift
//  Studor
//
//  Created by James Ahrens on 3/14/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import UIKit

class CreateGroupViewController: UIViewController {
    
    @IBOutlet weak var groupNameTextField: UITextField!
    
    @IBOutlet weak var addParticipantsTextField: UITextField!
    
    var groupName: String!
    var participants: [String]! // should have userID's, may also want to make this a tuple and contain nickname as well
    
    override func viewDidLoad() {
        super.viewDidLoad()

        participants = [String]()
        participants.append("myself") // TODO: instead of self display userID
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        if groupNameTextField.text == "" || groupNameTextField == nil {
            // TODO: display error saying group name cannot be empty
        } else if participants.count == 1 {
            // TODO: display error saying group cannot be just you
        } else {
            // TODO: create group
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
    }
    */

}
