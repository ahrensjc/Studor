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
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func viewDidLoad(){
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        db = Firestore.firestore()
        emailSuffix = "@gcc.edu"
        createAccountAI.isHidden = true
    }

    @IBAction func tapSignUp(_ sender: Any){

        createAccountAI.startAnimating()

        if let email = emailBox?.text, let password = passwordBox?.text, let passwordConfirm = confirmPasswordBox?.text {

            if !credentialsValid(password: password, confirmPassword: passwordConfirm, email: email){
                self.createAccountAI.stopAnimating()
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

        let email = String((Auth.auth().currentUser?.email!)!)
        
        let prefix = String(email.dropLast(emailSuffix.count))
        
        let data: [String : Any] = [
            "email" : email,
            "username": prefix,
            "nickname" : prefix,
            "accountType" : getAccountType(),
            "groups" : [],
            "usersLiked" : [],
            "usersWhoHaveLiked" : [],
            "usersDisliked" : [],
            "usersWhoHaveDisliked" : [],
            "noLikes" : 0,
            "noDislikes" : 0,
            "profImgSpecifier" : [0, 0],
            "sendbirdID" : prefix,
            "events" : [],
            "tags" : [],
            "bio" : "Your bio here",
            "pricing" : "0"
        ]
        
        db.collection("Users").document(prefix).setData(data) { err in
            if let err = err {
                print("Error: \(err)")
            } else {
                print("User data document created with name: \(prefix)")
            }
        }

        SBDMain.initWithApplicationId("8414C656-F939-4B34-B56E-B2EBD373A6DC")

        //login()

        SBDMain.connect(withUserId: data["sendbirdID"] as! String) { (user, error) in
            guard error == nil else {   // Error.
                print(error as Any)
                return
            }
            firebaseSingleton.sendbirdUser = user
            SBDMain.updateCurrentUserInfo(withNickname: prefix, profileUrl: "http://www.newdesignfile.com/postpic/2014/07/generic-profile-avatar_352864.jpg", completionHandler: { (error) in
                // ...
            })
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
        return password.count >= 7 ? true : false
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
