//
//  ScheduleTableViewController.swift
//  Studor
//
//  Created by James Ahrens on 2/7/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//
import Firebase
import UIKit

class ScheduleTableViewController: UITableViewController {

    var studor: StudorFunctions?
    var db: Firestore!
    var data: [String : Any]?
    var events: [String : Any] = [:]
    
    
    
    @IBOutlet var eventTableView: UITableView!
    
    @IBAction func unwindToScheduleFromEventCreation(segue:UIStoryboardSegue){
        print("unwinding")
    }
    
    func getFirestoreEventData(){
        
        // Create a query against the collection.
        let docRef = db.collection("Events").document()
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                self.data = document.data()
                print("Event data: \(self.data)")
            } else {
                print("Document does not exist")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        getFirestoreEventData()
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! ScheduleTableViewCell

        //cell.eventLabel.text = self.data!["title"]! ?? "New Event"
        //cell.dateLabel.text = self.data!["date"]! ?? "2019-3-18"
        
        cell.eventLabel.text = "New Event"
        cell.dateLabel.text = "2019-3-18"

        return cell
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
