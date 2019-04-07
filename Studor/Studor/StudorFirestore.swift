//
//  StudorFirestore.swift
//  Studor
//
//  Created by Tyler Fehr on 2/10/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import Foundation
import Firebase
import SendBirdSDK

let firebaseSingleton = StudorFunctions()

class StudorFunctions {
    
    // Can get a list of events that a user is in
    // Be able to add an event
    
    
    var db: Firestore!
    var emailSuffix: String = "@gcc.edu"
    var sendbirdUser: SBDUser?
    
    init(){
        db = Firestore.firestore()
    }
    
    // creates an event
    func createEvent(users: [String], date: Date, title: String){
        
        let thisUsername = firebaseSingleton.getFirestoreIdForCurrentUser()
        
        let dataToAdd: [String : Any] = [
            "title" : title,
            "creator" : thisUsername,
            "participants" : users,
            "date" : date,
        ]
        
        var eventRef: DocumentReference? = nil
        eventRef = db.collection("Events").addDocument(data: dataToAdd) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Event document added with ID: \(eventRef!.documentID)")
            }
        }
        
        let eventId = String(eventRef!.documentID)
        
        let userRef = db.collection("Users").document(thisUsername)
    
        // Atomically add a new region to the "regions" array field.
        userRef.updateData([
                "events" : FieldValue.arrayUnion([eventId])
            ])
        
        self.updateEventsForUserDocuments(users: users, eventID: eventId)
    }
    
    func updateEventsForUserDocuments(users: [String], eventID: String){
        
        var ref: DocumentReference?
        
        for i in 1..<users.count{
            
            ref = db.collection("Users").document(users[i])
            ref!.updateData([
                    "events" : FieldValue.arrayUnion([eventID])
                ])
            
        }
        
    }
    
    func createGroup(channelName: String, sendbirdUrl: String){
        
        let groupData: [String: Any] = [
            "sendbirdUrl" : sendbirdUrl,
            "channelName" : channelName
        ]
        
        db.collection("Groups").addDocument(data: groupData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
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
    
    func getFirestoreIdForCurrentUser() -> String {
        return String(Auth.auth().currentUser!.email!.dropLast(emailSuffix.count))
    }
    
    func getSendbirdId() -> String {
        return String(Auth.auth().currentUser!.email!.dropLast(emailSuffix.count))
    }
}
