//
//  TagSearchViewController.swift
//  Studor
//
//  Created by JJ Swar on 2/10/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import UIKit
import Firebase
import iOSDropDown
import SendBirdSDK

class TagSearchViewController: UIViewController, UITextFieldDelegate{
    
    let notificationCenter: NotificationCenter = .default
    
    @IBOutlet weak var coursedDropDown: DropDown!
    var tagUpdatedList: String!
    
    @IBAction func updateTagsArray(_ sender: Any) {
        var foundTag = false
        for tag in TagList.list {
            if coursedDropDown.text! == tag {
                foundTag = true
            }
        }
        if foundTag {
            let db = Firestore.firestore()
            db.collection("Users").document(String(Auth.auth().currentUser!.email!.dropLast("@gcc.edu".count))).updateData ([
                "tags": FieldValue.arrayUnion([coursedDropDown.text as  Any])
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                    ProfileViewController.tagListDirty = true
                }
            }
        }
        coursedDropDown.text = ""
    }
    
    
    var courseList : [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coursedDropDown.optionArray = TagList.list
        coursedDropDown.listHeight = 120
        coursedDropDown.selectedRowColor = UIColor.white
        coursedDropDown.hideOptionsWhenSelect = false //list doesnt disspear when a course has been selected to avoid scrolling again if a course is accidentally tapped
        
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
