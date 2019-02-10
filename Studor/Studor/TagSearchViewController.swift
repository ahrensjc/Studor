//
//  TagSearchViewController.swift
//  Studor
//
//  Created by JJ Swar on 2/10/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import UIKit
import Firebase

class TagSearchViewController: UIViewController {

    @IBOutlet weak var textThing: UITextField!
    
    let db = Firestore.firestore()
    
    @IBAction func addTag(_ sender: Any) {
        db.collection("Users").document(Auth.auth().currentUser!.uid).setData([
            "tags": "Los Angeles",
        ])

    }
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
