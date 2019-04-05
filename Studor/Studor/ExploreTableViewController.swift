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
    
    var filteredGroups = [GroupResult]()
    
    var groupResults = [GroupResult]()
    
    var selectedResult : SearchResult!
    
    var selectedGroup : GroupResult!
    
    var profileDataCollected : Bool = false
    
    var otherDataCollectedOnce : Bool = false
    
    var profileData : [String : Any] = [:]
    
    var grabDataTimer : Timer!
    
    var filterData : Timer!
    
    var doOnce = false
    
    var isSearchingGroups = false
    
    let searchController = UISearchController(searchResultsController: nil)
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        if scope != "Groups" {
            isSearchingGroups = false
            filterContentForSearchText(searchController.searchBar.text!, scope: scope)
        }
        else {
            isSearchingGroups = true
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty() || searchController.searchBar.selectedScopeButtonIndex != 0
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All"){
        if !isSearchingGroups {
            filteredResults = searchResults.filter({(searchResult : SearchResult) -> Bool in
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
        else {
            filteredGroups = groupResults.filter({(groupResult : GroupResult) -> Bool in
                let matcher = scope == "Groups"
                if searchBarIsEmpty() {
                    return matcher
                }
                else {
                    return matcher && groupResult.channelName.lowercased().contains(searchText.lowercased())
                }
            })
        }
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
        grabProfileData()
        grabGroupData()
        grabDataTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(grabOtherDataOnce), userInfo: nil, repeats: true)
        filterData = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(filterDataFunc), userInfo: nil, repeats: true)
        let _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateResults), userInfo: nil, repeats: true)
    }
    
    func grabGroupData() {
        let ref = firebaseSingleton.db.collection("Groups")
        ref.getDocuments { (document, error) in
            if let document = document, document.count > 0 {
                for entry in document.documents {
                    self.groupResults.append(GroupResult(entry.data()["sendbirdURL"] as? String ?? "no url", entry.data()["channelName"] as? String ?? "no channel name"))
                }
            }
        }
    }
    
    func grabProfileData(){
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
    
    @objc func updateResults(){
        if(ExploreTableViewController.profileTagListDirty){
            ExploreTableViewController.profileTagListDirty = false
            grabProfileData()
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchingGroups {
            if isFiltering() {
                return filteredGroups.count
            }
            return groupResults.count
        }
        if isFiltering() {
            return filteredResults.count
        }
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearchingGroups {
            let cell = tableView.dequeueReusableCell(withIdentifier: "exploreGroupCell", for: indexPath) as! ExploreTableViewGroupCell
            if isFiltering() {
                cell.channelNameText = filteredGroups[indexPath.row].channelName
            }
            else {
                cell.channelNameText = groupResults[indexPath.row].channelName
            }
            cell.initialiseData()
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "exploreUserCell", for: indexPath) as! ExploreTableViewUserCell
            if isFiltering() {
                cell.nameText = filteredResults[indexPath.row].name
                cell.typeText = filteredResults[indexPath.row].type
            }
            else{
                cell.nameText = searchResults[indexPath.row].name
                cell.typeText = searchResults[indexPath.row].type
            }
            cell.initialiseData()
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if isSearchingGroups {
            if isFiltering() {
                selectedGroup = filteredGroups[indexPath.row]
            }
            else {
                selectedGroup = groupResults[indexPath.row]
            }
        }
        else {
            if isFiltering() {
                selectedResult = filteredResults[indexPath.row]
            }
            else {
                selectedResult = searchResults[indexPath.row]
            }
        }
        return indexPath;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if isSearchingGroups {
            
        }
        else {
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
    }
}
