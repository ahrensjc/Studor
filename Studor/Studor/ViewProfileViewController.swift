//
//  ViewProfileViewController.swift
//  Studor
//
//  Created by Sean Bamford on 2/24/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import UIKit
import Firebase
import SendBirdSDK

class ViewProfileViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var bioText: UILabel!
    @IBOutlet weak var tagText : UITextView!
    @IBOutlet weak var likeButton : UIButton!
    @IBOutlet weak var dislikeButton : UIButton!
    
    var accountType : String!
    var id : String!
    var username : String!
    var nickname : String!
    var bio : String!
    var tags : [String] = []
    var sendbirdID: String!
    var profileData: [String : Any]!
    var thisSendbirdID: String!
    
    //TODO: Pricing label for all users (will hide if student user)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nicknameLabel.layer.borderWidth = 1.5; //this is the width of the border of nickname om profile page
        self.nicknameLabel.layer.cornerRadius = 8; //rounded edges
        self.nicknameLabel.layer.borderColor = UIColor(red:137/250, green:17/250, blue:0/250, alpha: 1).cgColor //the color of the border
        // Do any additional setup after loading the view.
    }
    
    func doHideLikeButtons() {
        if accountType.contains("Student"){
            likeButton.isHidden = true
            dislikeButton.isHidden = true
        }
    }
    
    func initialiseFields(){
        usernameLabel.text = username ?? ""
        nicknameLabel.text = nickname ?? ""
        bioText.text = bio ?? ""
        for tag in tags {
            tagText.text!.append("\(tag)\n")
        }
        self.tagText.layer.borderWidth = 1; //this is the width of the border of nickname om profile page
        self.tagText.layer.cornerRadius = 8; //rounded edges
        self.tagText.layer.borderColor = UIColor(red:137/250, green:17/250, blue:0/250, alpha: 1).cgColor //the color of the border
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let ref = firebaseSingleton.db.collection("Users").document(Auth.auth().currentUser!.uid)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                self.profileData = document.data()!
                self.sendbirdID = self.profileData["sendbirdID"] as? String ?? "" //Initialize bio from firebase
                var myNickname = self.profileData["NickName"] as? String ?? ""
                print(self.thisSendbirdID)
                print(self.sendbirdID)
                
                let params = SBDGroupChannelParams()
                params.isPublic = false
                params.isEphemeral = false
                params.isDistinct = true
                params.addUserIds([self.sendbirdID, self.thisSendbirdID])
                params.operatorUserIds = ["rando1"]
                if myNickname == "" { myNickname = String(Auth.auth().currentUser!.email!.dropLast("@gcc.edu".count)) }
                if self.nickname == "" { self.nickname = self.username }
                params.name = (myNickname + " & " + self.nickname)
                
                SBDGroupChannel.createChannel(with: params) { (channel, error) in
                    guard error == nil else {   // Error.
                        print("error creating channel")
                        print(error as Any)
                        return
                    }
                    print("created 1:1 channel")
                    
                    let newMetaData = [self.sendbirdID : "accepted", self.thisSendbirdID : "invited"]
                    
                    channel?.createMetaData((newMetaData as? [String : String])!, completionHandler: { (metaData, error) in
                        guard error == nil else {   // Error.
                            print("error adding channel metadata")
                            print(error as Any)
                            return
                        }
                        print("succesfully added metadata")
                    })
                }
            } else {
                print("ERROR GETTING DATA")
            }
        }
        
        let child = segue.destination as! MessageKitViewController
        child.channelURL = channel!.channelUrl
        child.sendbirdID = self.sendbirdID
        child.sendbirdUser = nil
    }*/
    
    @IBAction func messageButtonTapped(_ sender: Any) {
        // Get sendbird id for self and person
        let ref = firebaseSingleton.db.collection("Users").document(String(Auth.auth().currentUser!.email!.dropLast("@gcc.edu".count)))
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                self.profileData = document.data()!
                self.sendbirdID = self.profileData["sendbirdID"] as? String ?? "" //Initialize bio from firebase
                var myNickname = self.profileData["NickName"] as? String ?? ""
                print(self.thisSendbirdID)
                print(self.sendbirdID)
                
                let params = SBDGroupChannelParams()
                params.isPublic = false
                params.isEphemeral = false
                params.isDistinct = true
                params.addUserIds([self.sendbirdID, self.thisSendbirdID])
                params.operatorUserIds = ["rando1"]
                //myNickname = String(Auth.auth().currentUser!.email!.dropLast("@gcc.edu".count))
                //if self.nickname == "" { self.nickname = self.username }
                params.name = (firebaseSingleton.getSendbirdId() + " " + self.username)
                
                SBDGroupChannel.createChannel(with: params) { (channel, error) in
                    guard error == nil else {   // Error.
                        print("error creating channel")
                        print(error as Any)
                        return
                    }
                    print("created 1:1 channel")
                    
                    let newMetaData = [self.sendbirdID : "accepted", self.thisSendbirdID : "invited"]
                    
                    channel?.createMetaData((newMetaData as? [String : String])!, completionHandler: { (metaData, error) in
                        guard error == nil else {   // Error.
                            print("error adding channel metadata")
                            print(error as Any)
                            return
                        }
                        print("succesfully added metadata")
                    })
                    
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let messageKitViewController = storyBoard.instantiateViewController(withIdentifier: "messageKit") as! MessageKitViewController
                    messageKitViewController.channelURL = channel!.channelUrl
                    messageKitViewController.sendbirdID = self.sendbirdID
                    messageKitViewController.sendbirdUser = firebaseSingleton.sendbirdUser
                    
                    //self.present(newViewController, animated: true, completion: nil)
                    self.navigationController?.pushViewController(messageKitViewController, animated: true)
                    
                }
            } else {
                print("ERROR GETTING DATA")
            }
        }
    }
    
    @IBAction func doLikeButton(_ sender: Any) {
        let ref = firebaseSingleton.db.collection("Users").document(id)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                let profileData = document.data()
                var didFindMe = false
                for user in profileData!["usersWhoHaveLiked"] as? [String] ?? [] {
                    if user == Auth.auth().currentUser!.uid {
                        didFindMe = true
                    }
                }
                var temp = profileData!["usersWhoHaveLiked"] as? [String] ?? []
                if didFindMe {
                    let ref1 = firebaseSingleton.db.collection("Users").document(Auth.auth().currentUser!.uid)
                    ref1.getDocument { (document, error) in
                        if let document = document, document.exists {
                            let profileData = document.data()
                            var temp1 = profileData!["usersLiked"] as? [String] ?? []
                            temp1.remove(at: temp1.firstIndex(of: self.id)!)
                            firebaseSingleton.db.collection("Users").document(Auth.auth().currentUser!.uid).updateData([
                                "usersLiked": temp1
                            ]) { err in
                                if let err = err {
                                    print("Error writing document: \(err)")
                                }
                                else {
                                    print("Document successfully written!")
                                }
                            }
                        }
                    }
                    temp.remove(at: temp.firstIndex(of: Auth.auth().currentUser!.uid)!)
                    firebaseSingleton.db.collection("Users").document(self.id).updateData(
                        ["usersWhoHaveLiked": temp]
                    ) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        }
                        else {
                            print("Document successfully written!")
                        }
                    }
                }
                else {
                    let ref1 = firebaseSingleton.db.collection("Users").document(Auth.auth().currentUser!.uid)
                    ref1.getDocument { (document, error) in
                        if let document = document, document.exists {
                            let profileData = document.data()
                            var temp1 = profileData!["usersLiked"] as? [String] ?? []
                            temp1.append(self.id)
                            firebaseSingleton.db.collection("Users").document(Auth.auth().currentUser!.uid).updateData([
                                "usersLiked": temp1
                            ]) { err in
                                if let err = err {
                                    print("Error writing document: \(err)")
                                }
                                else {
                                    print("Document successfully written!")
                                }
                            }
                        }
                    }
                    temp.append(Auth.auth().currentUser!.uid)
                    firebaseSingleton.db.collection("Users").document(self.id).updateData(
                        ["usersWhoHaveLiked": temp]
                    ) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        }
                        else {
                            print("Document successfully written!")
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func doDislikeButton(_ sender: Any) {
        let ref = firebaseSingleton.db.collection("Users").document(id)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                let profileData = document.data()
                var didFindMe = false
                for user in profileData!["usersWhoHaveDisliked"] as? [String] ?? [] {
                    if user == Auth.auth().currentUser!.uid {
                        didFindMe = true
                    }
                }
                var temp = profileData!["usersWhoHaveDisliked"] as? [String] ?? []
                if didFindMe {
                    let ref1 = firebaseSingleton.db.collection("Users").document(Auth.auth().currentUser!.uid)
                    ref1.getDocument { (document, error) in
                        if let document = document, document.exists {
                            let profileData = document.data()
                            var temp1 = profileData!["usersDisliked"] as? [String] ?? []
                            temp1.remove(at: temp1.firstIndex(of: self.id)!)
                            firebaseSingleton.db.collection("Users").document(Auth.auth().currentUser!.uid).updateData([
                                "usersDisliked": temp1
                            ]) { err in
                                if let err = err {
                                    print("Error writing document: \(err)")
                                }
                                else {
                                    print("Document successfully written!")
                                }
                            }
                        }
                    }
                    temp.remove(at: temp.firstIndex(of: Auth.auth().currentUser!.uid)!)
                    firebaseSingleton.db.collection("Users").document(self.id).updateData(
                        ["usersWhoHaveDisliked": temp]
                    ) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        }
                        else {
                            print("Document successfully written!")
                        }
                    }
                }
                else {
                    let ref1 = firebaseSingleton.db.collection("Users").document(Auth.auth().currentUser!.uid)
                    ref1.getDocument { (document, error) in
                        if let document = document, document.exists {
                            let profileData = document.data()
                            var temp1 = profileData!["usersDisliked"] as? [String] ?? []
                            temp1.append(self.id)
                            firebaseSingleton.db.collection("Users").document(Auth.auth().currentUser!.uid).updateData([
                                "usersDisliked": temp1
                            ]) { err in
                                if let err = err {
                                    print("Error writing document: \(err)")
                                }
                                else {
                                    print("Document successfully written!")
                                }
                            }
                        }
                    }
                    temp.append(Auth.auth().currentUser!.uid)
                    firebaseSingleton.db.collection("Users").document(self.id).updateData(
                        ["usersWhoHaveDisliked": temp]
                    ) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        }
                        else {
                            print("Document successfully written!")
                        }
                    }
                }
            }
        }
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
