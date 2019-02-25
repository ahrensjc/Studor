//
//  ViewProfileViewController.swift
//  Studor
//
//  Created by Sean Bamford on 2/24/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import UIKit

class ViewProfileViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var bioText: UILabel!
    @IBOutlet weak var tagText : UILabel!
    
    var username : String!
    var nickname : String!
    var bio : String!
    var tags : [String] = []
    
    //TODO: Pricing label for all users (will hide if student user)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    func initialiseFields(){
        usernameLabel.text = username ?? ""
        nicknameLabel.text = nickname ?? ""
        bioText.text = bio ?? ""
        tagText.numberOfLines = tags.count
        for tag in tags {
            tagText.text!.append("\(tag)\n")
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
