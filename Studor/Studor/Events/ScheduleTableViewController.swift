//
//  ScheduleTableViewController.swift
//  Studor
//
//  Created by James Ahrens on 2/7/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//
import Firebase
import UIKit


class Event{
    var date: Date?
    var title: String?
    var participants: [String]?
    var eventId: String?
    var creator: String?
    var loc: String?
    
    init(date: Date, title: String, participants: [String], eventId: String, creator: String, loc: String){
        self.date = date
        self.title = title
        self.participants = participants
        self.eventId = eventId
        self.creator = creator
        self.loc = loc
    }
}

class ScheduleTableViewController: UITableViewController {

    var studor: StudorFunctions?
    var db: Firestore!
    var events: [Event] = []
    var rawData: [String]?
    var selectedEvent: Event?
    var selectedTime: String?
    
    @IBOutlet var eventTableView: UITableView!
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func unwindToScheduleFromEventCreation(segue:UIStoryboardSegue){
        print("unwinding")
    }

    
    func getEventIdList(completion: @escaping ([String]?, Error?) -> Void){
        
        // Create a query against the collection.
        let docRef = db.collection("Users").document(firebaseSingleton.getFirestoreIdForCurrentUser())
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let eventIds = document.data()!["events"] as! [String]
                completion(eventIds, nil)
            } else {
                print("Document does not exist")
                completion(nil, error)
            }
        }
    }

    func getEventDetails(eventIds: [String]){

        for eventId in eventIds {
            createEventFromId(id: eventId, completion:{ (newEvent) in
                if let newEvent = newEvent {
                    self.events.append(newEvent)
                    self.eventTableView.reloadData()
                    self.sortTableByDate()
                }
                else{
                    print("error initializing event for id: " + eventId)
                }
            })
        }
    }
    
    func createEventFromId(id: String, completion: @escaping (Event?) -> Void){
        
        var date: Date?
        var title: String?
        var participants: [String]?
        var location: String?
    
        let docRef = db.collection("Events").document(id)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                date = Date(timeIntervalSince1970: TimeInterval((document.data()!["date"] as! Timestamp).seconds))
                
                if Date() > date! {
                    print("Removing Event because it's date has already passed")
                    completion(nil)
                    return
                }
                
                title = (document.data()!["title"] as! String)
                participants = (document.data()!["participants"] as! [String])
                location = (document.data()?["location"]  ?? "HAL") as? String
                let newEvent = Event(date: date!, title: title!, participants: participants!, eventId: id, creator: firebaseSingleton.getFirestoreIdForCurrentUser(), loc: location!)
                completion(newEvent)
            } else {
                print("Event does not exist")
                completion(nil)
            }
        }
    }
    
    @objc private func refreshData(_ sender: Any) {
        
        DispatchQueue.main.async {
            self.events.removeAll()
            self.getCompleteEventData()
            self.sortTableByDate()
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
        
    }
    
    func initializeRefreshControl(){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:0.581, green:0.088, blue:0.319, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing Events...")
        self.refreshControl = refreshControl
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        db = Firestore.firestore()
        initializeRefreshControl()
        getCompleteEventData()
    }

    func getCompleteEventData(){
        self.getEventIdList(completion: { (eventIds, error) in
            if let eventIds = eventIds {
                self.getEventDetails(eventIds: eventIds)
            }
            else{
                print("Error reading eventIds; value is nil")
            }
        })
    }
    
    func sortTableByDate(){
        print("Sort table view")
        events.sort(by: {
            $0.date!.compare($1.date!) == .orderedAscending
        })
    }
    
    func removeExpiredEvents(){
        
        let currentTime = Date()
        
        for (i, event) in events.enumerated() {
            if event.date! < currentTime {
                events.remove(at: i)
                print("removed " + event.title!)
                
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! ScheduleTableViewCell
        

        let dateText = convertTimeToTwelveHourFormat(date: events[indexPath.row].date!)
        
        cell.dateLabel.text = dateText
        cell.eventLabel.text = events[indexPath.row].title

        return cell
    }
    
    func convertTimeToTwelveHourFormat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        formatter.dateFormat = "MM/dd HH:mm"
        
        let dateText = formatter.string(from: date)
        var outDate = ""
        
        if let inDate = formatter.date(from: dateText) {
            formatter.dateFormat = "MM/dd h:mm a"
            outDate = formatter.string(from: inDate)
            
        } else {
            print("Error converting time to proper format")
            outDate = "err"
        }
        
        return outDate
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Navigate to event details page from row tap
        
        selectedEvent = events[indexPath.row]
        selectedTime = convertTimeToTwelveHourFormat(date: events[indexPath.row].date!)
        
        performSegue(withIdentifier: "eventInTableTapped", sender: self)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowHeight = CGFloat(66.0)
        return rowHeight
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "eventInTableTapped") {

            var dest = segue.destination as! EventViewController

            dest.selectedEvent = self.selectedEvent!
            dest.timeOfEvent = selectedTime!
            print("segue to details page")
        }
    }

}


