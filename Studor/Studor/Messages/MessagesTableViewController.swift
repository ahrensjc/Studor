//
//  MessagesTableViewController.swift
//  Studor
//
//  Created by James Ahrens on 2/8/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import UIKit
import SendBirdSDK
import Firebase

class MessagesTableViewController: UITableViewController {
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    let loadingView = UIView()
    let loadingLabel = UILabel()
    
    //var myChannels = [SBDGroupChannel]()
    var myChannels = [(chan: SBDGroupChannel, accepted: Bool)]()
    var selected = -1
    var sendbirdID: String!
    var profileData: [String : Any]!
    var sendbirdUser: SBDUser!
    var tableReady = false
    
    //internal let refreshControl = UIRefreshControl()

    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // This should go in the login page later... (connects app to our sendbird project)
        //SBDMain.initWithApplicationId("8414C656-F939-4B34-B56E-B2EBD373A6DC")
        
        setLoadingScreen()
        let ref = firebaseSingleton.db.collection("Users").document(Auth.auth().currentUser!.uid)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                self.profileData = document.data()!
                self.sendbirdID = self.profileData["sendbirdID"] as? String ?? "" //Initialize bio from firebase
                self.login()
            } else {
                print("ERROR GETTING DATA")
            }
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:0.581, green:0.088, blue:0.319, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Channel Data...")
        self.refreshControl = refreshControl
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myChannels.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as! MessagesTableViewCell
        
        if !tableReady {
            cell.titleLabel.text = "Loading..."
            return cell
        }
        
        if myChannels[indexPath.item].accepted {
            cell.titleLabel.text = myChannels[indexPath.item].chan.name
        } else {
            cell.titleLabel.text = "INVITITATION: " + myChannels[indexPath.item].chan.name
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selected = indexPath.item // Keep track of what is selected so you can send it in the segue
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = self.contextualDeleteAction(forRowAtIndexPath: indexPath)
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeConfig.performsFirstActionWithFullSwipe = false
        return swipeConfig
    }
    
    func contextualDeleteAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal,
                                        title: "Delete") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
                                            self.myChannels[indexPath.item].chan.leave { (error) in
                                                guard error == nil else {   // Error.
                                                    print("error leaving channel")
                                                    print(error as Any)
                                                    return
                                                }
                                                //self.refreshData(self)
                                                self.myChannels.remove(at: indexPath.item)
                                                DispatchQueue.main.async {
                                                    self.tableView.reloadData()
                                                }
                                            }
        }
        action.title = "Leave Group"
        action.backgroundColor = UIColor.red
        return action
    }
    
    @IBAction func createGroupButtonTapped(_ sender: Any) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cgvc") as? CreateGroupViewController {
                if let navigator = navigationController {
                    navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is MessageKitViewController{
            let child = segue.destination as! MessageKitViewController
            child.channelURL = myChannels[selected].chan.channelUrl
            child.nickname = self.profileData["NickName"] as? String ?? ""
            child.sendbirdID = self.sendbirdID
            child.sendbirdUser = self.sendbirdUser
            print("checked correctly")
        } else if segue.destination is CreateGroupViewController {
            let child = segue.destination as! CreateGroupViewController
            child.nickname = self.profileData["NickName"] as? String ?? ""
            child.sendbirdID = self.sendbirdID
            child.sendbirdUser = self.sendbirdUser
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func login() {
        // Again this should go in the login page... (logs in user)
        SBDMain.connect(withUserId: sendbirdID, completionHandler: { (user, error) in
            self.sendbirdUser = user
            //let query = SBDGroupChannel.createPublicGroupChannelListQuery()
            self.refreshData(self)
        })
    }
    
    @objc private func refreshData(_ sender: Any) {
        let query = SBDGroupChannel.createMyGroupChannelListQuery()
        query?.includeEmptyChannel = true
        query?.limit = 100
        query?.loadNextPage(completionHandler: { (channels, error) in
            guard error == nil else {   // Error.
                print("error grabbing channel list")
                print(error as Any)
                return
            }
            
            self.myChannels = [(chan: SBDGroupChannel, accepted: Bool)]()
            self.tableReady = false
            for myChannel in channels! {
                let keys = [self.sendbirdID]
                myChannel.getMetaData(withKeys: keys as? [String], completionHandler: { (metaData, error) in
                    guard error == nil else {   // Error.
                        print("error getting channel metadata")
                        print(error as Any)
                        return
                    }
                    if metaData!.count == 0 {
                        self.myChannels.append((myChannel, true))
                    } else {
                        for data in metaData! {
                            if data.value as! String == "invited" {
                                self.myChannels.append((myChannel, false))
                            } else {
                                self.myChannels.append((myChannel, true))
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableReady = true
                        self.tableView.reloadData()
                        self.refreshControl?.endRefreshing()
                        self.removeLoadingScreen()
                    }
                })
            }
        })
    }
    
    // Set the activity indicator into the main view
    private func setLoadingScreen() {
        
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2) - (width / 2)
        let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        // Sets loading text
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
        
        // Sets spinner
        //activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.tintColor = UIColor(red:0.581, green:0.088, blue:0.319, alpha:1.0)
        activityIndicator.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(activityIndicator)
        loadingView.addSubview(loadingLabel)
        
        tableView.addSubview(loadingView)
    }
    
    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {
        
        // Hides and stops the text and the spinner
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        loadingLabel.isHidden = true
    }

}
