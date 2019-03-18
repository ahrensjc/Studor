//
//  StudorFirestore.swift
//  Studor
//
//  Created by Tyler Fehr on 2/10/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import Foundation
import Firebase

let firebaseSingleton = StudorFunctions()

class StudorFunctions {
    
    // Can get a list of events that a user is in
    // Be able to add an event
    
    
    var db: Firestore!
    
    init(){
        db = Firestore.firestore()
    }
    
    // creates an event
    func createEvent(users: [String], date: Date, description: String, title: String){
        
        let dataToAdd: [String : Any] = [
            "title" : title,
            "creator" : getId(),
            "participants" : users,
            "date" : date,
            "description" : description,
        ]
        
        let eventId = getId() + "-e"
        
        let eventRef = db.collection("Users").document(firebaseSingleton.getId())
    
        // Atomically add a new region to the "regions" array field.
        eventRef.updateData([
            "events": FieldValue.arrayUnion([eventId])
            ])
        
        db.collection("Events").document(eventId).setData(dataToAdd) { err in
            if let err = err {
                print("Error: \(err)")
                
            } else {
                print("Event created with event id: \(eventId)")
            }
        }
        self.updateEventsForUserDocuments(users: users)
    }
    
    func updateEventsForUserDocuments(users: [String]){
        
    }
    
    
    // Returns profile information of the user with the given firestore uID (bio, tags, nickname, etc.) in a [String : Any] if successful and nil otherwise
    func getProfileData(uid: String) -> [String : Any]{
        
        let ref = db.collection("Users").document(uid)
        
        var profileInfo: [String : Any] = [:]
        
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                profileInfo = document.data()!
            } else {
                print("Error retrieving profile data for user \(uid)")
            }
        }
        return profileInfo
    }
    
    func getId() -> String {
        return Auth.auth().currentUser!.uid
    }
}
