//
//  SignInSignUp.swift
//  Studor
//
//  Created by Sean Bamford on 2/5/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import UIKit

class SignInSignUp : UIViewController {

    @IBOutlet weak var usernameBox : UITextField?

    @IBOutlet weak var passwordBox : UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func tapSignIn() {
        if(usernameBox.text?.count <= 0 || passwordBox.text?.count <= 0) {
            return
        }
    }
}