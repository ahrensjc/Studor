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
    
    static var list: [String] = ["COMP 314", "COMP 443", "ACCT 101", "HUMA 301",
                          "COMP 123", "COMP 222", "COMP 232", "COMP 221",
                          "COMP 201", "COMP 202", "COMP 313", "COMP 341",
                          "COMP 445", "COMP 401", "COMP 455", "COMP 402",]
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
