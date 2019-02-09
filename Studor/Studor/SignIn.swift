//
//  SignInSignUp.swift
//  Studor
//
//  Created by Sean Bamford on 2/5/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SignIn : UIViewController {

    @IBOutlet weak var usernameBox : UITextField!

    @IBOutlet weak var passwordBox : UITextField!
    
    let ref: DatabaseReference = Database.database().reference()
    
    let handle: AuthStateDidChangeListenerHandle? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func tapSignIn() {
        if(usernameBox!.text!.count > 0 && passwordBox!.text!.count > 0) {
            signInUser(email: usernameBox.text!, password: passwordBox.text!)
            return
        }
    }
    
    func signInUser(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            
            //if let us
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
}
