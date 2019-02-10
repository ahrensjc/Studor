//
//  TagList.swift
//  Studor
//
//  Created by Tyler Fehr on 2/5/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import Foundation



class TagList{
    
    
    // TODO FOR SPRINT 2
    // Scrape all class course codes and add to list array
    
    var list: [String] = ["COMP 314", "COMP 443", "ACCT 101", "HUMA 301"]
    /*
    
    func parseRtf(){
        
        var contents: String = "none"
        
        if let filepath = Bundle.main.path(forResource: "TagData", ofType: "rtf") {
            do {
                contents = try String(contentsOfFile: filepath)
                print(contents)
                rawFileToArray(contents: contents)
            } catch {
                print("file error")
            }
        } else {
            print("file not found")
        }
    }
    
    func rawFileToArray(contents: String){
        //var data: [String] = String(contents.split(separator: ","))
        
    }
 */
}

let tagDB = TagList()
