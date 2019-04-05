//
//  TagSearchViewController.swift
//  Studor
//
//  Created by JJ Swar on 2/10/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import UIKit
import Firebase
import iOSDropDown
import SendBirdSDK

class TagSearchViewController: UIViewController, UITextFieldDelegate{
    
    let notificationCenter: NotificationCenter = .default

    @IBOutlet weak var textThing: UITextField!
    @IBOutlet weak var tagPageTags: UITextView!
    
    @IBOutlet weak var coursedDropDown: DropDown!
    var tagUpdatedList: String!
    
    @IBAction func updateTagsArray(_ sender: Any) {
        let db = Firestore.firestore()
        db.collection("Users").document(String(Auth.auth().currentUser!.email!.dropLast("@gcc.edu".count))).updateData([
            "tags": FieldValue.arrayUnion([coursedDropDown.text as Any])
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                ProfileViewController.tagListDirty = true
            }
        }
    }
    

    
    // autofill
    /*
    var rowCount = 1
    
    var autoCompletionPossibilities = ["COMP 420", "COMP 300"] //This is what we need to populate
    var autoCompleteCharacterCount = 0
    var timer = Timer()
    
    func textField(_ textThing: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { //1
        var subString = (textThing.text!.capitalized as NSString).replacingCharacters(in: range, with: string) // 2
        subString = formatSubstring(subString: subString)
        
        if subString.count == 0 { // 3 when a user clears the textField
            resetValues()
        } else {
            searchAutocompleteEntriesWithSubstring(substring: subString) //4
        }
        return true
    }
    func formatSubstring(subString: String) -> String {
        let formatted = String(subString.dropLast(autoCompleteCharacterCount)).uppercased().capitalized //5
        return formatted
    }
    
    func resetValues() {
        autoCompleteCharacterCount = 0
        textThing.text = ""
    }
    
    func searchAutocompleteEntriesWithSubstring(substring: String) {
        let userQuery = substring
        let suggestions = getAutocompleteSuggestions(userText: substring) //1
        // variable for timer interval; get rid of "magic number"
        
        if suggestions.count > 0 {
            timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (timer) in //2
                let autocompleteResult = self.formatAutocompleteResult(substring: substring, possibleMatches: suggestions) // 3
                self.putColourFormattedTextInTextField(autocompleteResult: autocompleteResult, userQuery : userQuery) //4
                self.moveCaretToEndOfUserQueryPosition(userQuery: userQuery) //5
            })
        } else {
            timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (timer) in //7
                self.textThing.text = substring
            })
            autoCompleteCharacterCount = 0
        }
    }
    
    func getAutocompleteSuggestions(userText: String) -> [String]{
        var possibleMatches: [String] = []
        for item in autoCompletionPossibilities { //2
            let myString:NSString! = item as NSString
            let substringRange :NSRange! = myString.range(of: userText)
            
            if (substringRange.location == 0)
            {
                possibleMatches.append(item)
            }
        }
        return possibleMatches
    }
    
    func putColourFormattedTextInTextField(autocompleteResult: String, userQuery : String) {
        let colouredString: NSMutableAttributedString = NSMutableAttributedString(string: userQuery + autocompleteResult)
        colouredString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 137/250, green: 17/250, blue: 0/250, alpha: 1), range: NSRange(location: userQuery.count,length:autocompleteResult.count))
        self.textThing.attributedText = colouredString
    }
    func moveCaretToEndOfUserQueryPosition(userQuery : String) {
        if let newPosition = self.textThing.position(from: self.textThing.beginningOfDocument, offset: userQuery.count) {
            self.textThing.selectedTextRange = self.textThing.textRange(from: newPosition, to: newPosition)
        }
        let selectedRange: UITextRange? = textThing.selectedTextRange
        textThing.offset(from: textThing.beginningOfDocument, to: (selectedRange?.start)!)
    }
    func formatAutocompleteResult(substring: String, possibleMatches: [String]) -> String {
        var autoCompleteResult = possibleMatches[0]
        autoCompleteResult.removeSubrange(autoCompleteResult.startIndex..<autoCompleteResult.index(autoCompleteResult.startIndex, offsetBy: substring.count))
        autoCompleteCharacterCount = autoCompleteResult.count
        return autoCompleteResult
    }*/
    //// end of autofill ////
    
    var courseList : [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tagPageTags.text = tagUpdatedList
        coursedDropDown.optionArray = TagList().list
        coursedDropDown.listHeight = 120
        coursedDropDown.selectedRowColor = UIColor.white
        coursedDropDown.hideOptionsWhenSelect = false //list doesnt disspear when a course has been selected to avoid scrolling again if a course is accidentally tapped
        
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
