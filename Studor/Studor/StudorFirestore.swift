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
    func createEvent(users: [String], date: Date, description: String){
        
        let dataToAdd: [String : Any] = [
            "creator" : getId(),
            "participants" : users,
            "date" : date,
            "description" : description,
        ]
        
        let eventId = getId() + "-e"
        
        
        let docRef = db.collection("Users").document(firebaseSingleton.getId())
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                
                self.db.collection("Users").document(firebaseSingleton.getId()).setData(["events": [eventId, document.data()!["events"]]], merge: true)
            } else {
                print("Document does not exist")
            }
        }
        
        
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
    
    // to create or OVERWRITE data for a current user
    func add(data: [String : Any], user: String){
        
        db.collection("Users").document(user).setData(data) { err in
            if let err = err {
                print("Error: \(err)")
            } else {
                print("Added data successfully")
            }
        }
    }
    
    func getId() -> String {
        return Auth.auth().currentUser!.uid
    }
}
