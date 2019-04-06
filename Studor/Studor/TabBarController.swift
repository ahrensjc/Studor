//
//  TabBarController.swift
//  Studor
//
//  Created by Tyler Fehr on 2/9/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import UIKit
import Firebase
import SendBirdSDK

class TabBarController: UITabBarController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // If user is not logged in while loading this view, log them out and navigate to login screen
        if Auth.auth().currentUser == nil {
            performSegue(withIdentifier: "requireLogin", sender: self)
        } else {
            SBDMain.initWithApplicationId("8414C656-F939-4B34-B56E-B2EBD373A6DC")
            //print(firebaseSingleton.getId())
            SBDMain.connect(withUserId: firebaseSingleton.getSendbirdId() ) { (user, error) in
                guard error == nil else {
                    print("failed logging in to sendbird")
                    print(error as Any)
                    return
                }
                firebaseSingleton.sendbirdUser = user
                print("worked")
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
