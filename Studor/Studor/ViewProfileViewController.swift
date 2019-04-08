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
    
    let likeButtonImageColour = UIImage(named: "likeColor")
    let likeButtonImage = UIImage(named: "like")
    let dislikeButtonImageColour = UIImage(named: "dislikeColor")
    let dislikeButtonImage = UIImage(named: "dislike")
    
    var likeListDirty = false
    var dislikeListDirty = false
    
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
        likeButton.setImage(likeButtonImage, for: .normal)
        dislikeButton.setImage(dislikeButtonImage, for: .normal)
        likeListDirty = true
        let _ = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(setLikeButtonColours), userInfo: nil, repeats: true)
    }
    
    @objc func setLikeButtonColours() {
        if username != nil && (likeListDirty || dislikeListDirty) {
            likeListDirty = false
            dislikeListDirty = false
            let ref = firebaseSingleton.db.collection("Users").document(username)
            ref.getDocument { (document, error) in
                if let document = document, document.exists {
                    let profileData = document.data()
                    var didFindMeInDislikes = false
                    var didFindMeInLikes = false
                    for user in profileData!["usersWhoHaveDisliked"] as? [String] ?? [] {
                        if user == String(Auth.auth().currentUser!.email!.dropLast("@gcc.edu".count)) {
                            didFindMeInDislikes = true
                        }
                    }
                    for user in profileData!["usersWhoHaveLiked"] as? [String] ?? [] {
                        if user == String(Auth.auth().currentUser!.email!.dropLast("@gcc.edu".count)) {
                            didFindMeInLikes = true
                        }
                    }
                    if didFindMeInDislikes {
                        self.dislikeButton.setImage(self.dislikeButtonImageColour, for: .normal)
                    }
                    else {
                        self.dislikeButton.setImage(self.dislikeButtonImage, for: .normal)
                    }
                    if didFindMeInLikes {
                        self.likeButton.setImage(self.likeButtonImageColour, for: .normal)
                    }
                    else {
                        self.likeButton.setImage(self.likeButtonImage, for: .normal)
                    }
                }
            }
        }
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
        let ref = firebaseSingleton.db.collection("Users").document(String(Auth.auth().currentUser!.email!.dropLast("@gcc.edu".length)))
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
                let _ = self.profileData["nickname"] as? String ?? ""
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
        let ref = firebaseSingleton.db.collection("Users").document(username)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                let profileData = document.data()
                var didFindMe = false
                for user in profileData!["usersWhoHaveLiked"] as? [String] ?? [] {
                    if user == String(Auth.auth().currentUser!.email!.dropLast("@gcc.edu".count)) {
                        didFindMe = true
                    }
                }
                var temp = profileData!["usersWhoHaveLiked"] as? [String] ?? []
                if didFindMe {
                    let ref1 = firebaseSingleton.db.collection("Users").document(String(Auth.auth().currentUser!.email!.dropLast("@gcc.edu".count)))
                    ref1.getDocument { (document, error) in
                        if let document = document, document.exists {
                            let profileData = document.data()
                            var temp1 = profileData!["usersLiked"] as? [String] ?? []
                            temp1.remove(at: temp1.firstIndex(of: self.username)!)
                            firebaseSingleton.db.collection("Users").document(String(Auth.auth().currentUser!.email!.dropLast("@gcc.edu".count))).updateData([
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
                    temp.remove(at: temp.firstIndex(of: String(Auth.auth().currentUser!.email!.dropLast("@gcc.edu".count)))!)
                    firebaseSingleton.db.collection("Users").document(self.username).updateData(
                        ["usersWhoHaveLiked": temp]
                    ) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        }
                        else {
                            print("Document successfully written!")
                            self.likeListDirty = true
                        }
                    }
                }
                else {
                    let ref1 = firebaseSingleton.db.collection("Users").document(String(Auth.auth().currentUser!.email!.dropLast("@gcc.edu".count)))
                    ref1.getDocument { (document, error) in
                        if let document = document, document.exists {
                            let profileData = document.data()
                            var temp1 = profileData!["usersLiked"] as? [String] ?? []
                            var temp2 = profileData!["usersDisliked"] as? [String] ?? []
                            var didFindMe2 = false
                            for user in temp2 {
                                if user == self.username {
                                    didFindMe2 = true
                                }
                            }
                            if didFindMe2 {
                                temp2.remove(at: temp2.firstIndex(of: self.username)!)
                                firebaseSingleton.db.collection("Users").document(String(Auth.auth().currentUser!.email!.dropLast("@gcc.edu".count))).updateData(
                                ["usersDisliked" : temp2]
                                ) { err in
                                    if let err = err {
                                        print("Error writing document: \(err)")
                                    }
                                    else {
                                        print("Document successfully written!")
                                    }
                                }
                            }
                            temp1.append(self.username)
                            firebaseSingleton.db.collection("Users").document(String(Auth.auth().currentUser!.email!.dropLast("@gcc.edu".count))).updateData([
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
                    var temp2 = profileData!["usersWhoHaveDisliked"] as? [String] ?? []
                    var didFindMe2 = false
                    for user in temp2 {
                        if user == String(Auth.auth().currentUser!.email!.dropLast("@gcc.edu".count)) {
                            didFindMe2 = true
                        }
                    }
                    if didFindMe2 {
                        temp2.remove(at: temp2.firstIndex(of: String(Auth.auth().currentUser!.email!.dropLast("@gcc.edu".count)))!)
                        firebaseSingleton.db.collection("Users").document(self.username).updateData(
                        ["usersWhoHaveDisliked" : temp2]) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            }
                            else {
                                print("Document successfully written!")
                            }
                        }
                    }
                    temp.append(String(Auth.auth().currentUser!.email!.dropLast("@gcc.edu".count)))
                    firebaseSingleton.db.collection("Users").document(self.username).updateData(
                        ["usersWhoHaveLiked": temp]
                    ) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        }
                        else {
                            print("Document successfully written!")
                            self.likeListDirty = true
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func doDislikeButton(_ sender: Any) {
        let ref = firebaseSingleton.db.collection("Users").document(username)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                let profileData = document.data()
                var didFindMe = false
                for user in profileData!["usersWhoHaveDisliked"] as? [String] ?? [] {
                    if user == String(Auth.auth().currentUser!.email!.dropLast("@gcc.edu".count)) {
                        didFindMe = true
                    }
                }
                var temp = profileData!["usersWhoHaveDisliked"] as? [String] ?? []
                if didFindMe {
                    let ref1 = firebaseSingleton.db.collection("Users").document(String(Auth.auth().currentUser!.email!.dropLast("@gcc.edu".count)))
                    ref1.getDocument { (document, error) in
                        if let document = document, document.exists {
                            let profileData = document.data()
                            var temp1 = profileData!["usersDisliked"] as? [String] ?? []
                            temp1.remove(at: temp1.firstIndex(of: self.username)!)
                            firebaseSingleton.db.collection("Users").document(String(Auth.auth().currentUser!.email!.dropLast("@gcc.edu".count))).updateData([
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
                    temp.remove(at: temp.firstIndex(of: String(Auth.auth().currentUser!.email!.dropLast("@gcc.edu".count)))!)
                    firebaseSingleton.db.collection("Users").document(self.username).updateData(
                        ["usersWhoHaveDisliked": temp]
                    ) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        }
                        else {
                            print("Document successfully written!")
                            self.dislikeListDirty = true
                        }
                    }
                }
                else {
                    let ref1 = firebaseSingleton.db.collection("Users").document(String(Auth.auth().currentUser!.email!.dropLast("@gcc.edu".count)))
                    ref1.getDocument { (document, error) in
                        if let document = document, document.exists {
                            let profileData = document.data()
                            var temp1 = profileData!["usersDisliked"] as? [String] ?? []
                            var temp2 = profileData!["usersLiked"] as? [String] ?? []
                            var didFindMe2 = false
                            for user in temp2 {
                                if user == self.username {
                                    didFindMe2 = true
                                }
                            }
                            if didFindMe2 {
                                temp2.remove(at: temp2.firstIndex(of: self.username)!)
                                firebaseSingleton.db.collection("Users").document(String(Auth.auth().currentUser!.email!.dropLast("@gcc.edu".count))).updateData(
                                    ["usersLiked" : temp2]
                                ) { err in
                                    if let err = err {
                                        print("Error writing document: \(err)")
                                    }
                                    else {
                                        print("Document successfully written!")
                                    }
                                }
                            }
                            temp1.append(self.username)
                            firebaseSingleton.db.collection("Users").document(String(Auth.auth().currentUser!.email!.dropLast("@gcc.edu".count))).updateData([
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
                    var temp2 = profileData!["usersWhoHaveLiked"] as? [String] ?? []
                    var didFindMe2 = false
                    for user in temp2 {
                        if user == String(Auth.auth().currentUser!.email!.dropLast("@gcc.edu".count)) {
                            didFindMe2 = true
                        }
                    }
                    if didFindMe2 {
                        temp2.remove(at: temp2.firstIndex(of: String(Auth.auth().currentUser!.email!.dropLast("@gcc.edu".count)))!)
                        firebaseSingleton.db.collection("Users").document(self.username).updateData(
                        ["usersWhoHaveLiked" : temp2]) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            }
                            else {
                                print("Document successfully written!")
                            }
                        }
                    }
                    temp.append(String(Auth.auth().currentUser!.email!.dropLast("@gcc.edu".count)))
                    firebaseSingleton.db.collection("Users").document(self.username).updateData(
                        ["usersWhoHaveDisliked": temp]
                    ) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        }
                        else {
                            print("Document successfully written!")
                            self.dislikeListDirty = true
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
