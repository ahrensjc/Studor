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
    
    @IBOutlet weak var memberList: UILabel?
    
    var channelName: String?
    var channelUrl: String?
    var sendbirdID: String?
    
    var channelMembers: [SBDUser]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // JJ You shouldn't need this line. But for some reason all the channels in the
        // explore page are dummy channels with bad channelUrl's. I'm guessing sean
        // will fix this soon but whatever.
        //channelUrl = "sendbird_group_channel_109631720_57d4c248c64df93c877860dc47eca9fc407a578d"
        
        SBDGroupChannel.getWithUrl(channelUrl!) { (groupChannel, error) in
            guard error == nil else {   // Error.
                print("error getting channel data")
                print(error as Any)
                return
            }
            
            self.channelMembers = (groupChannel!.members as! [SBDUser])
        }
    }
    
    

}
