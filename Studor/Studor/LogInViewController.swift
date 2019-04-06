//
//  LogInViewController.swift
//  Studor
//
//  Created by James Ahrens on 2/6/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import UIKit
import Firebase
import SendBirdSDK

class LogInViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var sendbirdTextField: UITextField!

    @IBAction func forgotPasswordButtonTapped(_ sender: Any) {
        // Make google do this part
    }
    
    @IBAction func logInButtonTapped(_ sender: Any) {

        if let email = usernameTextField.text, let password = passwordTextField.text{
            
            // Make sure whatever you put into the if let field actually exists or it will skip this block every time
            
            // if let sendbirdId = sendBirdTextField.text

            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in


                if user != nil && error == nil {
                    print("Login success")
                    self.performSegue(withIdentifier: "loginSuccess", sender: self)
                    
                    SBDMain.initWithApplicationId("8414C656-F939-4B34-B56E-B2EBD373A6DC")
                    
                    SBDMain.connect(withUserId: firebaseSingleton.getId() ) { (user, error) in
                        guard error == nil else {
                            print("failed logging in to sendbird")
                            print(error as Any)
                            return
                        }
                        firebaseSingleton.sendbirdUser = user
                        print("worked")
                    }
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
        
        if Auth.auth().currentUser != nil { // user is already logged in, so forward them to the home screen automatically
            
            
            SBDMain.initWithApplicationId("8414C656-F939-4B34-B56E-B2EBD373A6DC")
            
            SBDMain.connect(withUserId: firebaseSingleton.getId() ) { (user, error) in
                guard error == nil else {
                    print("failed logging in to sendbird")
                    print(error as Any)
                    self.performSegue(withIdentifier: "loginSuccess", sender: self)
                    return
                }
                firebaseSingleton.sendbirdUser = user
                print("worked")
                self.performSegue(withIdentifier: "loginSuccess", sender: self)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
    }

    func showMessagePrompt(withString: String, title: String){
        let alert = UIAlertController(title: title, message: withString, preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }

}
