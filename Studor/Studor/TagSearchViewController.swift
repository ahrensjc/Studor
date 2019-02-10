//
//  TagSearchViewController.swift
//  Studor
//
//  Created by JJ Swar on 2/10/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TagSearchViewController: UIViewController {

    @IBOutlet weak var textThing: UITextField!
    
    var ref:DatabaseReference?
    
    @IBAction func addTag(_ sender: Any) {
        ref = Database.database().reference()
        ref?.child("Users").child("y1HXINHR8y5n954qes7r").child("tags").setValue("new")

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
