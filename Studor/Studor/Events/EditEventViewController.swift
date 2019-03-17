//
//  EditEventViewController.swift
//  Studor
//
//  Created by James Ahrens on 3/15/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import UIKit

class EditEventViewController: UIViewController {
    
    var eventID: String!

    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventDatePicker: UIDatePicker!
    @IBOutlet weak var eventLocationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: fill in event data into fields
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
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
