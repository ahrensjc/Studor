//
//  ProfileViewController.swift
//  Studor
//
//  Created by JJ Swar on 2/2/19.
//  Copyright © 2019 JJ Swar. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var bioText: UITextView!
    
    @IBAction func nicknameEdit(_ sender: Any) {
        // TODO
        // call up modal?
        // set nicknameLabel text
        // set database to new nickname
    }
    
    @IBAction func bioEdit(_ sender: Any) {
        // TODO
        // call up modal?
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
