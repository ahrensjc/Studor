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

class ResultParent {
    var type: String
    
    init(_ _type: String){
        type = _type
    }
}

class SearchResult : ResultParent {
    var name: String
    var nickname: String
    var id: String
    var tags: [String] = []
    
    init(_ _nickname : String, _ _name : String, _ _type : String, _ _id : String, _ _tags: [String]){
        name = _name
        id = _id
        tags.append(contentsOf: _tags)
        nickname = _nickname
        super.init(_type)
    }
}

class GroupResult : ResultParent {
    var sendbirdURL: String
    var channelName: String
    
    init(_ _sendbirdURL : String, _ _channelName : String) {
        sendbirdURL = _sendbirdURL
        channelName = _channelName
        super.init("Group")
    }
}

class ExploreTableViewController: UITableViewController, UITextFieldDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    static var profileTagListDirty = false
    
    var names : [String] = []
    
    var types : [String] = []
    
    var searchResults = [ResultParent]()
    
    var filteredResults = [ResultParent]()
    
    var selectedResult : ResultParent!
    
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
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty() || searchController.searchBar.selectedScopeButtonIndex != 0
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All"){
        filteredResults = searchResults.filter({(searchResult : ResultParent) -> Bool in
            let matcher = scope == "All" || searchResult.type == String(scope.dropLast(1))
            if searchBarIsEmpty() {
                return matcher
            }
            else {
                var tagsContainsSearchText = false
                if searchResult is SearchResult {
                    for tag in (searchResult as! SearchResult).tags {
                        if tag.lowercased().contains(searchText.lowercased()) {tagsContainsSearchText = true}
                    }
                }
                return matcher && (searchResult is SearchResult && ((searchResult as! SearchResult).name.lowercased().contains(searchText.lowercased()) || tagsContainsSearchText || (searchResult as! SearchResult).nickname.lowercased().contains(searchText.lowercased())) ||
                (searchResult is GroupResult && (searchResult as! GroupResult).channelName.lowercased().contains(searchText.lowercased())))
            }
        })
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let scope = searchBar.scopeButtonTitles![selectedScope]
        filterContentForSearchText(searchBar.text!, scope: scope)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchBar.tintColor = UIColor(red:0.491, green:0.119, blue:0.212, alpha:1.0)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.scopeButtonTitles = ["All", "Students", "Tutors", "Groups"]
        searchController.searchBar.delegate = self
        searchController.searchBar.accessibilityIdentifier = "Search Bar"
        navigationItem.searchController = searchController
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        grabProfileData()
        grabDataTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(grabOtherDataOnce), userInfo: nil, repeats: true)
        let _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateResults), userInfo: nil, repeats: true)
    }
    
    func grabGroupData() {
        let ref = firebaseSingleton.db.collection("Groups")
        ref.getDocuments { (document, error) in
            if let document = document, document.count > 0 {
                for entry in document.documents {
                    self.searchResults.append(GroupResult(entry.data()["sendbirdUrl"] as? String ?? "no url", entry.data()["channelName"] as? String ?? "no channel name"))
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func grabProfileData(){
        if Auth.auth().currentUser != nil {
            let ref = firebaseSingleton.db.collection("Users").document(String(Auth.auth().currentUser!.email!.dropLast(8)))
            ref.getDocument {(document, error) in
                if let document = document, document.exists {
                    self.profileData = document.data()!
                    self.profileDataCollected = true
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
                        if (entry.data()["username"] as? String ?? "no username") != String(Auth.auth().currentUser!.email!.dropLast("@gcc.edu".count)) {
                            self.searchResults.append(SearchResult(entry.data()["nickname"] as? String ?? "no nickname",     entry.data()["username"] as? String ?? "no username", entry.data()["accountType"] as? String ?? "no account type", entry.documentID, entry.data()["tags"] as? [String] ?? []))
                        }
                    }
                    self.otherDataCollectedOnce = true
                    self.tableView.reloadData()
                    self.grabGroupData()
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredResults.count
        }
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = isFiltering() ? filteredResults[indexPath.row] : searchResults[indexPath.row]
        if result is SearchResult {
            let cell = tableView.dequeueReusableCell(withIdentifier: "exploreUserCell", for: indexPath) as! ExploreTableViewUserCell
            cell.nameText = (result as! SearchResult).nickname
            cell.typeText = (result as! SearchResult).type
            cell.initialiseData()
            return cell
        }
        else if result is GroupResult {
            let cell = tableView.dequeueReusableCell(withIdentifier: "exploreGroupCell", for: indexPath) as! ExploreTableViewGroupCell
            cell.channelNameText = (result as! GroupResult).channelName
            cell.initialiseData()
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedResult = isFiltering() ? filteredResults[indexPath.row] : searchResults[indexPath.row]
        return indexPath;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if selectedResult is GroupResult {
            let destination = segue.destination as! ViewGroupProfileViewController
            let result = selectedResult as! GroupResult
            destination.channelUrl = result.sendbirdURL
            destination.channelName = result.channelName
        }
        else if selectedResult is SearchResult{
            let destination = segue.destination as! ViewProfileViewController
            let result = selectedResult as! SearchResult
            let ref = firebaseSingleton.db.collection("Users").document(result.id)
            var profileInfo: [String : Any] = [:]
            ref.getDocument { (document, error) in
                if let document = document, document.exists {
                    profileInfo = document.data()!
                    print(profileInfo["username"] as? String ?? "No username")
                    destination.accountType = profileInfo["accountType"] as? String ?? ""
                    destination.doHideLikeButtons()
                    destination.id = result.id
                    destination.bio = profileInfo["bio"] as? String ?? ""
                    destination.nickname = profileInfo["nickname"] as? String ?? ""
                    destination.tags = profileInfo["tags"] as? [String] ?? []
                    destination.username = profileInfo["username"] as? String ?? ""
                    destination.thisSendbirdID = profileInfo["sendbirdID"] as? String ?? ""
                    destination.upvoteCount = profileInfo["noLikes"] as? Int ?? 0
                    destination.downvoteCount = profileInfo["noDislikes"] as? Int ?? 0
                    destination.initialiseFields()
                } else {
                    print("Error retrieving profile data for user \(result.id)")
                }
            }
        }
    }
}
