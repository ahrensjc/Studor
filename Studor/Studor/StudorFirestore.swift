//
//  StudorFirestore.swift
//  Studor
//
//  Created by Tyler Fehr on 2/10/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import Foundation
import Firebase

class StudorFunctions {
    
    var db: Firestore!
    
    init(){
        db = Firestore.firestore()
    }
    
    func createEvent(with users: [String], on date: Date, with description: String) -> Bool {
        return false
    }
    
    
    // to create or OVERWRITE data for a current user
    func add(toFireStoreCollectionWith data: [String : Any]) -> Bool{
        
        var ret = false
        db.collection("Users").document(getFirestoreID()).setData(data) { err in
            if let err = err {
                print("Error: \(err)")
            } else {
                print("Added data successfully")
                ret = true
            }
        }
        return ret
    }
    
    // create a group in firestore. The creator should be the first element in the array passed in
    func createGroup(with users: [String]) -> Bool {
        let groupRef = db.collection("Groups")
        
        
        
        /*
         let sfReference = db.collection("cities").document("SF")
         
         db.runTransaction({ (transaction, errorPointer) -> Any? in
         let sfDocument: DocumentSnapshot
         do {
         try sfDocument = transaction.getDocument(sfReference)
         } catch let fetchError as NSError {
         errorPointer?.pointee = fetchError
         return nil
         }
         
         guard let oldPopulation = sfDocument.data()?["population"] as? Int else {
         let error = NSError(
         domain: "AppErrorDomain",
         code: -1,
         userInfo: [
         NSLocalizedDescriptionKey: "Unable to retrieve population from snapshot \(sfDocument)"
         ]
         )
         errorPointer?.pointee = error
         return nil
         }
         
         transaction.updateData(["population": oldPopulation + 1], forDocument: sfReference)
         return nil
         }) { (object, error) in
         if let error = error {
         print("Transaction failed: \(error)")
         } else {
         print("Transaction successfully committed!")
         }
         }
 */
        return false
    }
    
    private func addUserToGroup(withId: String, forUser id: String) -> Bool{
        return false
    }
    
    private func getFirestoreID() -> String {
        return Auth.auth().currentUser!.uid
    }
    
    
}
