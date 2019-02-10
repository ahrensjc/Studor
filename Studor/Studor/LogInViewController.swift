//
//  LogInViewController.swift
//  Studor
//
//  Created by James Ahrens on 2/6/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!

    @IBAction func forgotPasswordButtonTapped(_ sender: Any) {
        // Make google do this part
    }
    @IBAction func logInButtonTapped(_ sender: Any) {

        if let email = usernameTextField.text, let password = passwordTextField.text {

            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in


                if user != nil && error == nil {
                    print("Login success")
                    self.performSegue(withIdentifier: "loginSuccess", sender: self)
                } else {
                    print("Error:\(error!.localizedDescription)")
                }

                
            }
        }
        else {
            self.showMessagePrompt(withString: "Username or password fields are missing", title: "Error")
        }

    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        //performSegue(withIdentifier: "", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let user = Auth.auth().currentUser { // user is already logged in, so forward them to the home screen automatically
            self.performSegue(withIdentifier: "loginSuccess", sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !navigationItem.hidesBackButton {
            navigationItem.hidesBackButton = true
        }
    }

    func showMessagePrompt(withString: String, title: String){
        let alert = UIAlertController(title: title, message: withString, preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }

}

/*
 func signout(){
     let firebaseAuth = Auth.auth()
     do {
        try firebaseAuth.signOut()
     } catch let signOutError as NSError {
        print ("Error signing out: %@", signOutError)
     }
 }
 */
