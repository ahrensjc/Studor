//
//  SignUp.swift
//  Studor
//
//  Created by Sean Bamford on 2/5/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import UIKit
import Firebase
import SendBirdSDK

class SignUp : UIViewController {

    var db: Firestore!
    var emailSuffix: String!

    @IBOutlet weak var emailBox : UITextField!

    @IBOutlet weak var passwordBox: UITextField!

    @IBOutlet weak var confirmPasswordBox : UITextField!

    @IBOutlet weak var accountType : UISegmentedControl!

    @IBOutlet weak var createAccountAI: UIActivityIndicatorView!

    override func viewDidLoad(){
        super.viewDidLoad()
        db = Firestore.firestore()
        emailSuffix = "@gcc.edu"
        createAccountAI.isHidden = true
    }

    @IBAction func tapSignUp(_ sender: Any){

        createAccountAI.startAnimating()

        if let email = emailBox?.text, let password = passwordBox?.text, let passwordConfirm = confirmPasswordBox?.text {

            if !credentialsValid(password: password, confirmPassword: passwordConfirm, email: email){
                return
            }

            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in

                if error == nil && authResult != nil {


                    self.initializeUserAccount()
                    print("Account created for user \(email.dropLast(self.emailSuffix.count))")

                    self.createAccountAI.stopAnimating()
                    self.performSegue(withIdentifier: "signUpSuccess", sender: self)
                } else {
                    print("ERROR: \(error!.localizedDescription)")
                    self.showMessagePrompt(withString: error!.localizedDescription, title: "Error")
                }
            }
        }
        self.createAccountAI.stopAnimating()
    }

    func initializeUserAccount(){ // to firestore

        let data: [String : Any] = [
            "email" : Auth.auth().currentUser?.email!,
            "username": Auth.auth().currentUser?.email!.dropLast(emailSuffix.count),
            "accountType" : getAccountType(),
            "biography" : "A new user of Studor",
            "groups" : [],
            "profImgSpecifier" : [0, 0],
            "sendbirdID" : Auth.auth().currentUser!.uid,
            "tags" : ["COMP 314", "COMP 435", "COMP 420"]
        ]
        db.collection("Users").document(Auth.auth().currentUser!.uid).setData(data) { err in
            if let err = err {
                print("Error: \(err)")
            } else {
                print("User data document created with uID: \(Auth.auth().currentUser!.uid)")
            }
        }

        SBDMain.initWithApplicationId("8414C656-F939-4B34-B56E-B2EBD373A6DC")

        //login()

        SBDMain.connect(withUserId: data["sendbirdID"] as! String) { (user, error) in
            guard error == nil else {   // Error.
                print(error)
                return
            }
            print("worked")
        }

        //SBDMain.connect(withUserId: data["sendbirdID"] as! String, accessToken: "accessToken")

    }

    func getAccountType() -> String{
        return accountType.selectedSegmentIndex == 0 ? "Student" : "Tutor"
    }

    /*
     *      Error checking and input validation methods
     *
     */


func credentialsValid(password: String, confirmPassword: String, email: String) -> Bool{

        if !passwordsMatch(password: password, confirmPassword: confirmPassword) {
            showMessagePrompt(withString: "Password fields do not match", title: "Error")
            return false
        }

        if !isPasswordValidLength(password: password) {
            showMessagePrompt(withString: "Password must be at least 7 characters", title: "Error")
            return false
        }

        if !isValidEmail(email: email){
            showMessagePrompt(withString: "Studor is restricted to GCC students only.", title: "Error")
            return false
        }

        return true
    }

    func passwordsMatch(password: String, confirmPassword: String) -> Bool{
        return password == confirmPassword ? true : false
    }

    func isPasswordValidLength(password: String) -> Bool {
        return password.count >= 6 ? true : false
    }

    func isValidEmail(email: String) -> Bool {
        return email.hasSuffix(emailSuffix) ? true : false
    }

    func showMessagePrompt(withString: String, title: String) {
        let alert = UIAlertController(title: title, message: withString, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
