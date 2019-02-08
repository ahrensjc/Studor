//
//  SignUp.swift
//  Studor
//
//  Created by Sean Bamford on 2/5/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import UIKit

class SignUp : UIViewController {


    @IBOutlet weak var emailBox : UITextField?

    @IBOutlet weak var usernameBox : UITextField?

    @IBOutlet weak var passwordBox : UITextField?

    @IBOutlet weak var confirmPasswordBox : UITextField?

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

 if let email = emailTextField, let password = passwordTextField.text, let passwordConfirm = passwordConfirmTextField.text {
    if !email.endsWith("gcc.edu) {
    showMessagePrompt(withString: "Studor is restricted to GCC students only", title: "Error")
    return
    }
 if password != passwordConfirm {
    showMessagePrompt(withString: "Password fields do not match", title: "Error")
    return
 }
 if password.count < 7 {
    showMessagePrompt(withString: "Password must be at least 7 characters", title: "Error")
 }
 }

 Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in

    guard let user = authResult?.user else { return }
 }

 func showMessagePrompt(withString: String, title: String){
 let alert = UIAlertController(title: title, message: withString, preferredStyle: UIAlertController.Style.alert)

 // add an action (button)
 alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

 // show the alert
 self.present(alert, animated: true, completion: nil)
 }
 */

}
