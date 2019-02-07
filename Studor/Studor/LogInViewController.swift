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
    
    // PLEASE READ
    // I don't know how to automatically redirect past this page if the user has already signed in
    // Probably a sprint 2 task but for now it is something to think about
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func forgotUsernameButtonTapped(_ sender: Any) {
        //Make google do this part
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: Any) {
        // Make google do this part
    }
    @IBAction func logInButtonTapped(_ sender: Any) {
        // Grab username and pw and send them to the db
        // Encrypt them or does google handle that?
        
        if let email = emailTextField.text, let password = passwordTextField.text {
        
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                
                
                if let error = error {
                    // show message function call to user, additional method needed
                    self.showMessagePrompt(withString: error.localizedDescription, title: "Error")
                    return
                }
                
                // performSegue(withIdentifier: exploreViewController, sender: self)
            }
        }
        else {
            self.showMessagePrompt(withString: "Username or password fields are missing", title: "Error")
        }

    }
    @IBAction func signUpButtonTapped(_ sender: Any) {
        // performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO
        // autofill form data if user has already signed up/in?
        // redirect to main page if user has already signed in?
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func showMessagePrompt(withString: String, title: String){
        let alert = UIAlertController(title: title, message: withString, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }

}
