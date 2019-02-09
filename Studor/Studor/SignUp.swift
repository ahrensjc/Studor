//
//  SignUp.swift
//  Studor
//
//  Created by Sean Bamford on 2/5/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import UIKit
import Firebase

class SignUp : UIViewController {
    
    @IBOutlet weak var emailBox : UITextField!

    @IBOutlet weak var usernameBox : UITextField!

    @IBOutlet weak var passwordBox : UITextField!

    @IBOutlet weak var confirmPasswordBox : UITextField!

    @IBOutlet weak var accountType : UISegmentedControl!

    override func viewDidLoad(){
        super.viewDidLoad()
    }

    @IBAction func tapSignUp(_ sender: Any){
        if let email = emailBox.text, let password = passwordBox.text, let passwordConfirm = confirmPasswordBox.text {
            
            if !isValidPassword(password: password, confirmPassword: passwordConfirm) && !isValidEmail(email: email){
                return
            }
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                
                if error == nil && authResult != nil {
                    print("Account created")
                    self.performSegue(withIdentifier: "signUpSuccess", sender: self)
                } else {
                    print("Here it is: \(error!.localizedDescription)")
                    print("THERE IS SOMETHING WRONG AHHHH")
                    self.showMessagePrompt(withString: error!.localizedDescription, title: "Error")
                }
            }
        }
    }
        
    
    func showMessagePrompt(withString: String, title: String) {
        let alert = UIAlertController(title: title, message: withString, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func isValidPassword(password: String, confirmPassword: String) -> Bool{
        if password != confirmPassword {
            showMessagePrompt(withString: "Password fields do not match", title: "Error")
            return false
        }
        
        if password.count < 7 {
            showMessagePrompt(withString: "Password must be at least 7 characters", title: "Error")
            return false
        }
        return true
    }
    
    func isValidEmail(email: String) -> Bool {
        if !email.hasSuffix("@gcc.edu") {
            showMessagePrompt(withString: "Studor is restricted to GCC students only", title: "Error")
            return false
        }
        return true
    }
}
