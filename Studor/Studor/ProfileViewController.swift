//
//  ProfileViewController.swift
//  Studor
//
//  Created by JJ Swar on 2/2/19.
//  Copyright © 2019 JJ Swar. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var bioText: UITextView!
    
    @IBOutlet var nicknamePopover: UIView!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBAction func nicknameDone(_ sender: Any) {
        self.nicknamePopover.removeFromSuperview()
    }
    @IBAction func nicknameCancel(_ sender: Any) {
        self.nicknamePopover.removeFromSuperview()
    }
    
    @IBOutlet var bioPopover: UIView!
    @IBOutlet weak var bioTextView: UITextView!
    @IBAction func bioCancel(_ sender: Any) {
        self.bioPopover.removeFromSuperview()
    }
    @IBAction func bioDone(_ sender: Any) {
        self.bioPopover.removeFromSuperview()
    }
    
    var db: DatabaseReference!
    
    @IBAction func nicknameEdit(_ sender: Any) {
        // TODO
        self.view.addSubview(nicknamePopover)
        nicknamePopover.center = self.view.center
        nicknameTextField.text = nicknameLabel.text
        // set nicknameLabel text
        // set database to new nickname
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("Success logging out")
            self.performSegue(withIdentifier: "logoutSuccess", sender: self)
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            
        }
    }

    
    
    @IBAction func bioEdit(_ sender: Any) {
        // TODO
        // call up modal?
        self.view.addSubview(bioPopover)
        bioPopover.center = self.view.center
        bioTextView.text = bioText.text
        // set bio text
        // set database to new bio text
    }
    
    @IBAction func tagEdit(_ sender: Any) {
        // TODO
        // call up modal?
        // set tags
        // set database to new tags
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nicknamePopover.layer.cornerRadius = 10
        self.bioPopover.layer.cornerRadius = 10
        
        // This function runs when the page is opened for the first time in app
        // TODO
        // get and set username data label text
        // get and set nickname data label text
        // get and set bio data text
        // get and set tag data
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
