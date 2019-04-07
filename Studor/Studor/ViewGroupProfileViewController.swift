//
//  ViewGroupProfileViewController.swift
//  Studor
//
//  Created by JJ 2 on 4/5/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import SendBirdSDK

class ViewGroupProfileViewController: UIViewController {
    
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var memberList: UITextView?
    
    var channelName: String?
    var channelUrl: String?
    var sendbirdID: String?
    
    var channelMembers: [SBDUser]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.groupName.layer.borderWidth = 1.5; //this is the width of the border of nickname om profile page
        self.groupName.layer.cornerRadius = 8; //rounded edges
        self.groupName.layer.borderColor = UIColor(red:137/250, green:17/250, blue:0/250, alpha: 1).cgColor //the color of the border
        
        SBDGroupChannel.getWithUrl(channelUrl!) { (groupChannel, error) in
            guard error == nil else {   // Error.
                print("error getting channel data")
                print(error as Any)
                return
            }
            
            self.groupName.text = groupChannel?.name
            
            self.channelMembers = (groupChannel!.members as! [SBDUser])
            
            self.memberList!.text = ""
            
            for member in self.channelMembers {
                let append =  "\n" + member.nickname!
                self.memberList!.text.append(append)
                
            }
            
            
            
        }
      
    }
}
    
    


