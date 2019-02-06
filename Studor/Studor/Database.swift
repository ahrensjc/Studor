//
//  Database.swift
//  Studor
//
//  Created by Tyler Fehr on 2/5/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import Foundation
import FirebaseDatabase

//https://firebase.google.com/docs/auth/web/password-auth#create_a_password-based_account

class Database {
    var ref: DatabaseReference!
    
    init(){
        //ref = Database.database().reference()
        ref = ref.database.reference()
    }

    
    func createUser(username: String, email: String, password: String){
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            // ...
            guard let user = authResult?.user else { return }
        }
    }
    
    func addTag(for user: String){
        
    }
    
    /*
    func getContacted(for user: String) -> [String]{
        return
    }
    */
}

