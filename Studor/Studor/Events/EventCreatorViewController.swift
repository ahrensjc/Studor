//
//  EventCreatorViewController.swift
//  Studor
//
//  Created by James Ahrens on 3/14/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import UIKit

class EventCreatorViewController: UIViewController {

    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventDatePicker: UIDatePicker!
    @IBOutlet weak var eventLocationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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