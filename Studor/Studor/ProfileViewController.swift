//
//  ProfileViewController.swift
//  Studor
//
//  Created by JJ Swar on 2/2/19.
//  Copyright © 2019 JJ Swar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SendBirdSDK
import QuartzCore



class ProfileViewController: UIViewController, UITextFieldDelegate{
    
    
    static var tagListDirty = false
    
    let notificationCenter: NotificationCenter = .default
    
    var suffix: String = "@gcc.edu"

    var commands: StudorFunctions!
    var profileData: [String : Any]!
    
    var tagX: Double!
    var tagY: Double!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var tagTextView: UITextView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioText: UITextView!
    
    @IBOutlet weak var initializeBio: UITextView! //pull bio info from database to initialize
    
    
    //TODO: Pricing label for all users (will hide if student user)
    @IBOutlet weak var pricingTextLabel: UILabel!
    @IBOutlet var nicknamePopover: UIView!
    @IBOutlet weak var nicknameTextField: UITextField!
    
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let child = segue.destination as! TagSearchViewController
        child.tagUpdatedList = tagTextView.text
    } */
   
    @IBAction func nicknameCancel(_ sender: Any) {
        self.nicknamePopover.removeFromSuperview()
    }
    
    @IBOutlet var bioPopover: UIView!
    @IBOutlet weak var bioTextView: UITextView!
    @IBAction func bioCancel(_ sender: Any) {
        self.bioPopover.removeFromSuperview()
    }
    
    @IBAction func bioDone(_ sender: Any) {
        let db = Firestore.firestore()
        db.collection("Users").document(String(Auth.auth().currentUser!.email!.dropLast(suffix.count))).updateData([
            "bio": bioTextView.text
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            }
            else {
                self.bioText.text = self.bioTextView.text
                print("Document successfully written!")
            }
        }
        self.bioPopover.removeFromSuperview()
    }
    
    @IBAction func nicknameDone(_ sender: Any) {
        let db = Firestore.firestore()
        db.collection("Users").document(String(Auth.auth().currentUser!.email!.dropLast(suffix.count))).updateData([
            "nickname": nicknameTextField.text!
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            }
            else {
                SBDMain.updateCurrentUserInfo(withNickname: self.nicknameTextField.text!, profileUrl: "http://www.newdesignfile.com/postpic/2014/07/generic-profile-avatar_352864.jpg", completionHandler: { (error) in
                    // ...
                })
                self.nicknameLabel.text = self.nicknameTextField.text
                print("Document successfully written!")
            }
        }
        self.nicknamePopover.removeFromSuperview()
    }
    
    var db: DatabaseReference!
    
    @IBAction func logOutButton(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("Success logging out")
            firebaseSingleton.sendbirdUser = nil
            self.performSegue(withIdentifier: "logoutSuccess", sender: self)
            
            SBDMain.disconnect(completionHandler: {
                //Disconnects user from the SendBird server
            })
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func updateTags(_ sender: Any) {
        let db = Firestore.firestore()
        db.collection("Users").document(String(Auth.auth().currentUser!.email!.dropLast(suffix.count))).updateData([
            "tags": FieldValue.arrayUnion([tagTextView.text])
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    @IBAction func nicknameEdit(_ sender: Any) {
        // 1.
        var nicknameTextField: UITextField?
        
        // 2.
        let alertController = UIAlertController(
            title: "Edit Display Name",
            message: "",
            preferredStyle: .alert)
        
        // 3.
        let saveNicknameAction = UIAlertAction(
        title: "Save", style: .default) {
            (action) -> Void in
            
            if let nickname = nicknameTextField?.text {
                let db = Firestore.firestore()
                db.collection("Users").document(firebaseSingleton.getFirestoreIdForCurrentUser()).updateData([
                    "nickname": nickname
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    }
                    else {
                        SBDMain.updateCurrentUserInfo(withNickname: self.nicknameTextField.text!, profileUrl: "http://www.newdesignfile.com/postpic/2014/07/generic-profile-avatar_352864.jpg", completionHandler: { (error) in
                            // ...
                        })
                        self.nicknameLabel.text = nickname
                        print("Document successfully written!")
                    }
                }
            }
        }
        
        let cancelNicknameAction = UIAlertAction(
        title: "Cancel", style: .cancel) {
            (action) -> Void in
            print("canceled")
        }
        
        //editNicknameAction.
        
        // 4.
        alertController.addTextField {
            (txtUsername) -> Void in
            nicknameTextField = txtUsername
            nicknameTextField!.text = self.nicknameLabel.text
        }
        
        // 5.
        alertController.addAction(saveNicknameAction)
        alertController.addAction(cancelNicknameAction)
        alertController.view.tintColor = UIColor(red:0.491, green:0.119, blue:0.212, alpha:1.0)
        present(alertController, animated: true, completion: nil)
        
        //self.view.addSubview(nicknamePopover)
        //nicknamePopover.center = self.view.center
        //nicknameTextField.text = nicknameLabel.text
    }
    @IBAction func bioEdit(_ sender: Any) {
        // 1.
        //var nicknameTextField: UITextField?
        var bioEdit: UITextField?
        
        // 2.
        let alertController = UIAlertController(
            title: "Edit Bio",
            message: "",
            preferredStyle: .alert)
        
        // 3.
        let saveBioAction = UIAlertAction(
        title: "Save", style: .default) {
            (action) -> Void in
            
            if let bio = bioEdit?.text {
                let db = Firestore.firestore()
                db.collection("Users").document(firebaseSingleton.getFirestoreIdForCurrentUser()).updateData([
                    "bio": bio
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    }
                    else {
                        self.bioText.text = bio
                        print("Document successfully written!")
                    }
                }
            }
        }
        
        let cancelBioAction = UIAlertAction(
        title: "Cancel", style: .cancel) {
            (action) -> Void in
            print("canceled")
        }
        
        //editNicknameAction.
        
        // 4.
        alertController.addTextField {
            (txtUsername) -> Void in
            bioEdit = txtUsername
            bioEdit!.text = self.bioText.text
        }
        
        // 5.
        alertController.addAction(saveBioAction)
        alertController.addAction(cancelBioAction)
        alertController.view.tintColor = UIColor(red:0.491, green:0.119, blue:0.212, alpha:1.0)
        present(alertController, animated: true, completion: nil)
        
        
        //self.view.addSubview(bioPopover)
        //bioPopover.center = self.view.center
        //bioTextView.text = bioText.text
    }
    
    
    @IBAction func tagEdit(_ sender: Any) {
        // TODO
        // call up modal?
        // set tags
        // set database to new tags
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? DeleteTagsViewController ?? nil
        if(destination != nil){
            destination!.tagList = profileData["tags"] as? [String] ?? []
        }
    }
    
    
    /*
    func frameOfTextInRange(range: NSRange, tag: UITextView) -> CGRect {
        let beginning = tag.beginningOfDocument
        let start = tag.positionFromPosition(beginning, offset: range.location)!
        let end = tag.positionFromPosition(start, offset: range.length)!
        let textRange = tag.textRangeFromPosition(start, toPosition: end)!
        let rect = tag.firstRectForRange(textRange)
        return tag.convertRect(rect, fromView: tagTextView)
    }
    
    func drawTags(){
        let pattern = "[a-zA-Z0-9]+"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = regex.matches(in: tagTextView.text!, options: [], range: NSMakeRange(0, tagTextView.text!.characters.count))
        
        for m in matches {
            let range = m.range
            let frame = frameOfTextInRange(range: range, tag: tagTextView)
            let v = UIView(frame: frame)
            v.layer.borderWidth = 1
            v.layer.borderColor = UIColor.blue.cgColor
            tagTextView.addSubview(v)
        }
    }
 */
    /*
    func frameOfTextInRange(range:NSRange, inTextView textView:UITextView) -> CGRect {
        let beginning = textView.beginningOfDocument
        let start = textView.positionFromPosition(beginning, offset: range.location)!
        let end = textView.positionFromPosition(start, offset: range.length)!
        let textRange = textView.textRangeFromPosition(start, toPosition: end)!
        let rect = textView.firstRectForRange(textRange)
        return textView.convertRect(rect, fromView: textView)
    }
    
    let string = "Lorem ipsum dolor sit amet"
    
    let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    textView.backgroundColor = UIColor.clearColor()
    
    textView.attributedText = {
    let attributedString = NSMutableAttributedString(string: string)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineHeightMultiple = 1.25
    attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, string.characters.count))
    attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSMakeRange(0, string.characters.count))
    
    let regex = try! NSRegularExpression(pattern: "\\s", options: [])
    let matches = regex.matchesInString(string, options: [], range: NSMakeRange(0, string.characters.count))
    for m in matches {
    attributedString.addAttribute(NSKernAttributeName, value: 6, range: m.range)
    }
    return NSAttributedString(attributedString: attributedString)
    }()
    
    let textViewBG = UIView(frame: textView.bounds)
    textViewBG.backgroundColor = UIColor.whiteColor()
    
    
    let pattern = "[^ ]+"
    let regex = try! NSRegularExpression(pattern: pattern, options: [])
    let matches = regex.matchesInString(string, options: [], range: NSMakeRange(0, string.characters.count))
    
    for m in matches {
    textViewBG.addSubview({
    let range = m.range
    var frame = frameOfTextInRange(range, inTextView: textView)
    frame = CGRectInset(frame, CGFloat(-3), CGFloat(2))
    frame = CGRectOffset(frame, CGFloat(0), CGFloat(3))
    let v = UIView(frame: frame)
    v.layer.cornerRadius = 2
    v.backgroundColor = UIColor(hue: 211.0/360.0, saturation: 0.35, brightness: 0.78    , alpha: 1)
    return v
    }())
    }
    
    textViewBG.addSubview(textView)
 */
    
    func updateProfileUI(){
        nicknameLabel.text = profileData["nickname"] as? String
        bioText.text! = profileData["bio"] as? String ?? ""
        
        let tags = profileData["tags"]
    }
    
    func appendTags(arr: [String]) -> String {
        return arr.joined(separator: " ")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameLabel.text = String(Auth.auth().currentUser!.email!.dropLast("@gcc.edu".count))
        self.nicknameLabel.layer.borderWidth = 1.5; //this is the width of the border of nickname om profile page
        self.nicknameLabel.layer.cornerRadius = 8; //rounded edges
        self.nicknameLabel.layer.borderColor = UIColor(red:137/250, green:17/250, blue:0/250, alpha: 1).cgColor //the color of the border
        self.tagTextView.layer.borderWidth = 1; //this is the width of the border of nickname om profile page
        self.tagTextView.layer.cornerRadius = 8; //rounded edges
        self.tagTextView.layer.borderColor = UIColor(red:137/250, green:17/250, blue:0/250, alpha: 1).cgColor //the color of the border
        
        let ref = firebaseSingleton.db.collection("Users").document(String(Auth.auth().currentUser!.email!.dropLast(suffix.count)))
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                self.tagTextView.text = ""
                self.profileData = document.data()!
                self.bioText.text = self.profileData["bio"] as? String ?? "" //Initialize bio from firebase
                for item in self.profileData["tags"] as? [String] ?? [] {
                    self.tagTextView.text.append("\(item)\n")
                }
                //print(self.profileData["nickname"])
                self.nicknameLabel.text = self.profileData["nickname"] as? String
                
                self.usernameLabel.text = self.profileData["username"] as? String
                if self.profileData["accountType"] as! String == "Student" {
                    self.pricingTextLabel.isHidden = true
                }
                self.updateProfileUI()
                //do something to handle fetching tags
            }
        }
        self.nicknamePopover.layer.cornerRadius = 10
        self.bioPopover.layer.cornerRadius = 10
        let _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.shouldUpdateTagList), userInfo: nil, repeats: true)
    }
    
    func onTagListDirty(){
        let ref = firebaseSingleton.db.collection("Users").document(String(Auth.auth().currentUser!.email!.dropLast(suffix.count)))
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                self.tagTextView.text = ""
                self.profileData = document.data()!
                for item in self.profileData["tags"] as? [String] ?? [] {
                    self.tagTextView.text.append("\(item)\n")
                }
            }
        }
    }
    
    @objc func shouldUpdateTagList(){
        if ProfileViewController.tagListDirty {
            ProfileViewController.tagListDirty = false
            onTagListDirty()
            ExploreTableViewController.profileTagListDirty = true
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
