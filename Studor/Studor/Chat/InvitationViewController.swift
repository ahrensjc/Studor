//
//  InvitationViewController.swift
//  Studor
//
//  Created by James Ahrens on 3/16/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import UIKit

protocol invDelegate {
    func accepted(child: InvitationViewController)
    func declined(child: InvitationViewController)
}

class InvitationViewController: UIViewController {
    
    var delegate: invDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func acceptButtonTapped(_ sender: Any) {
        delegate.accepted(child: self)
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func declineButtonTapped(_ sender: Any) {
        delegate.declined(child: self)
        self.navigationController?.popViewController(animated: false)
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
