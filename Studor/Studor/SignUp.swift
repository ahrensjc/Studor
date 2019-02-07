//
//  SignUp.swift
//  Studor
//
//  Created by Sean Bamford on 2/5/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import UIKit

class SignUp : UIViewController {
    
    @IBOutlet weak var emailBox : UITextBox?
    
    @IBOutlet weak var usernameBox : UITextBox?
    
    @IBOutlet weak var passwordBox : UITextBox?
    
    @IBOutlet weak var confirmPasswordBox : UITextBox?
    
    @IBOutlet weak var accountType : UISegmentedControl?

    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    @IBAction func tapSignUp(_ sender: Any){
        if emailBox!.text!.count > 0 && usernameBox!.text!.count > 0 && passwordBox!.text!.count > 0 && confirmPasswordBox!.text!.count > 0 && passwordBox!.text == confirmPasswordBox!.text {
            //do sign up
        }
    }
    
/*
 Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in

    guard let user = authResult?.user else { return }
 }
 */

}
