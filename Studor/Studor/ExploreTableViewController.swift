//
//  ExploreTableViewController.swift
//  Studor
//
//  Created by James Ahrens on 2/2/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class SearchResult {
    var name: String
    var type: String
    var id: String
    var tags: [String] = []
    
    init(_ _name : String, _ _type : String, _ _id : String, _ _tags: [String]){
        name = _name
        type = _type
        id = _id
        tags.append(contentsOf: _tags)
    }
}

class GroupResult {
    var sendbirdURL: String
    var channelName: String
    
    init(_ _sendbirdURL : String, _ _channelName : String) {
        sendbirdURL = _sendbirdURL
        channelName = _channelName
    }
}

class ExploreTableViewController: UITableViewController, UITextFieldDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    static var profileTagListDirty = false
    
    var rowCount = 0
    
    var names : [String] = []
    
    var types : [String] = []
    
    var searchResults = [SearchResult]()
    
    var commonTagResults = [SearchResult]()
    
    var filteredResults = [SearchResult]()
    
    var groupResults = [GroupResult]()
    
    var selectedResult : SearchResult!
    
    var profileDataCollected : Bool = false
    
    var otherDataCollectedOnce : Bool = false
    
    var profileData : [String : Any] = [:]
    
    var grabDataTimer : Timer!
    
    var filterData : Timer!
    
    var doOnce = false
    
    let searchController = UISearchController(searchResultsController: nil)
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        if scope != "Groups" {
            filterContentForSearchText(searchController.searchBar.text!, scope: scope)
        }
        else {
            
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty() || searchController.searchBar.selectedScopeButtonIndex != 0
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All"){
        filteredResults = commonTagResults.filter({(searchResult : SearchResult) -> Bool in
            let matcher = (scope == "All") || (searchResult.type == scope)
            if searchBarIsEmpty() {
                return matcher
            }
            else {
                return matcher && searchResult.name.lowercased().contains(searchText.lowercased())
            }
        })
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.scopeButtonTitles = ["All", "Student", "Tutor", "Groups"]
        searchController.searchBar.delegate = self
        searchController.searchBar.accessibilityIdentifier = "Search Bar"
        navigationItem.searchController = searchController
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        doGrabProfileData()
        grabDataTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(grabOtherDataOnce), userInfo: nil, repeats: true)
        filterData = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(filterDataFunc), userInfo: nil, repeats: true)
        let _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(shouldUpdateResults), userInfo: nil, repeats: true)
    }
    
    func doGrabProfileData(){
        if Auth.auth().currentUser != nil {
            let ref1 = firebaseSingleton.db.collection("Users").document(Auth.auth().currentUser!.uid)
            ref1.getDocument {(document, error) in
                if let document = document, document.exists {
                    self.profileData = document.data()!
                    self.profileDataCollected = true
                    if self.otherDataCollectedOnce {
                        self.filterDataFunc()
                    }
                }
            }
        }
    }
    
    @objc func shouldUpdateResults(){
        if(ExploreTableViewController.profileTagListDirty){
            ExploreTableViewController.profileTagListDirty = false
            doGrabProfileData()
        }
    }
    
    @objc func grabOtherDataOnce() {
        if profileDataCollected {
            self.grabDataTimer.invalidate()
            let ref = firebaseSingleton.db.collection("Users")
            ref.getDocuments { (document, error) in
                if let document = document, document.count > 0 {
                    for entry in document.documents {
                        self.searchResults.append(SearchResult(entry.data()["username"] as? String ?? "no username", entry.data()["accountType"] as? String ?? "no account type", entry.documentID, entry.data()["tags"] as? [String] ?? []))
                    }
                    self.otherDataCollectedOnce = true
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func filterDataFunc() {
        if otherDataCollectedOnce {
            filterData.invalidate()
            commonTagResults = searchResults.filter({(searchResult : SearchResult) -> Bool in
                if(profileData["username"] as! String != searchResult.name) {
                    let selfTags = profileData["tags"] as? [String] ?? []
                    if selfTags.count <= 0 || (selfTags.count == 1 && selfTags[0] == ""){
                        return true
                    }
                    else {
                        for tag in selfTags {
                            for _tag in searchResult.tags {
                                if tag.lowercased() == _tag.lowercased() {
                                    return true
                                }
                            }
                        }
                    }
                }
                return false
            })
            tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // We may need more than this but get it later
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isFiltering() {
            return filteredResults.count
        }
        return commonTagResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exploreCell", for: indexPath) as! ExploreTableViewCell
        if isFiltering() {
            cell.nameText = filteredResults[indexPath.row].name
            cell.typeText = filteredResults[indexPath.row].type
        }
        else{
            cell.nameText = commonTagResults[indexPath.row].name
            cell.typeText = commonTagResults[indexPath.row].type
        }
        cell.initialiseData()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if isFiltering() {
            selectedResult = filteredResults[indexPath.row]
        }
        else {
            selectedResult = commonTagResults[indexPath.row]
        }
        return indexPath;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ViewProfileViewController
        let ref = firebaseSingleton.db.collection("Users").document(selectedResult.id)
        var profileInfo: [String : Any] = [:]
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                profileInfo = document.data()!
                print(profileInfo["username"] as? String ?? "No username")
                destination.accountType = profileInfo["accountType"] as? String ?? ""
                destination.doHideLikeButtons()
                destination.id = self.selectedResult.id
                destination.bio = profileInfo["Bio"] as? String ?? ""
                destination.nickname = profileInfo["NickName"] as? String ?? ""
                destination.tags = profileInfo["tags"] as? [String] ?? []
                destination.username = profileInfo["username"] as? String ?? ""
                destination.thisSendbirdID = profileInfo["sendbirdID"] as? String ?? ""
                destination.initialiseFields()
            } else {
                print("Error retrieving profile data for user \(self.selectedResult.id)")
            }
        }
    }
    
    //autofill function
    
    @IBOutlet weak var textField: UITextField!
    
    var autoCompletionPossibilities = ["Apple", "Pineapple", "Orange"] //This is what we need to populate using the data base
    
    var autoCompleteCharacterCount = 0
    
    var timer = Timer()
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { //1
        var subString = (textField.text!.capitalized as NSString).replacingCharacters(in: range, with: string) // 2
        subString = formatSubstring(subString: subString)
        
        if subString.count == 0 { // 3 when a user clears the textField
            resetValues()
        } else {
            searchAutocompleteEntriesWithSubstring(substring: subString) //4
        }
        return true
    }
    func formatSubstring(subString: String) -> String {
        let formatted = String(subString.dropLast(autoCompleteCharacterCount)).lowercased().capitalized //5
        return formatted
    }
    
    func resetValues() {
        autoCompleteCharacterCount = 0
        textField.text = ""
    }
    
    func searchAutocompleteEntriesWithSubstring(substring: String) {
        let userQuery = substring
        let suggestions = getAutocompleteSuggestions(userText: substring) //1
        
        if suggestions.count > 0 {
            timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (timer) in //2
                let autocompleteResult = self.formatAutocompleteResult(substring: substring, possibleMatches: suggestions) // 3
                self.putColourFormattedTextInTextField(autocompleteResult: autocompleteResult, userQuery : userQuery) //4
                self.moveCaretToEndOfUserQueryPosition(userQuery: userQuery) //5
            })
        } else {
            timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (timer) in //7
                self.textField.text = substring
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
        colouredString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.green, range: NSRange(location: userQuery.count,length:autocompleteResult.count))
        self.textField.attributedText = colouredString
    }
    func moveCaretToEndOfUserQueryPosition(userQuery : String) {
        if let newPosition = self.textField.position(from: self.textField.beginningOfDocument, offset: userQuery.count) {
            self.textField.selectedTextRange = self.textField.textRange(from: newPosition, to: newPosition)
        }
        let selectedRange: UITextRange? = textField.selectedTextRange
        textField.offset(from: textField.beginningOfDocument, to: (selectedRange?.start)!)
    }
    func formatAutocompleteResult(substring: String, possibleMatches: [String]) -> String {
        var autoCompleteResult = possibleMatches[0]
        autoCompleteResult.removeSubrange(autoCompleteResult.startIndex..<autoCompleteResult.index(autoCompleteResult.startIndex, offsetBy: substring.count))
        autoCompleteCharacterCount = autoCompleteResult.count
        return autoCompleteResult
    }
    //// end of autofil////
}
