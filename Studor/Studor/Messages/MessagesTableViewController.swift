//
//  MessagesTableViewController.swift
//  Studor
//
//  Created by James Ahrens on 2/8/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import UIKit
import SendBirdSDK

class MessagesTableViewController: UITableViewController {
    
    var myChannels = [SBDGroupChannel]()
    var selected = -1
    
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
        SBDMain.initWithApplicationId("8414C656-F939-4B34-B56E-B2EBD373A6DC")
        
        login()
        
        
        //print("attempting to print channels: \(String(describing: channelQuery))")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myChannels.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as! MessagesTableViewCell

        // This should instead be the title of the channel if its a group or the person's nickname if it is 1:1 chat ???
        //cell.titleLabel.text = myChannels[indexPath.count].name
        cell.titleLabel.text = myChannels[indexPath.item].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selected = indexPath.item // Keep track of what is selected so you can send it in the segue
        return indexPath
    }
    @IBAction func createGroupButtonTapped(_ sender: Any) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cgvc") as? CreateGroupViewController {
                //viewController.newsObj = newsObj
                if let navigator = navigationController {
                    navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is MessageKitViewController{
            let child = segue.destination as! MessageKitViewController
            child.channelURL = myChannels[selected].channelUrl
            print("checked correctly")
        } else if segue.destination is CreateGroupViewController {
            //let child = segue.destination as! CreateGroupViewController
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
        SBDMain.connect(withUserId: "rando1", completionHandler: { (user, error) in
            // ...
            // Grab a list of channels the user is in
            let query = SBDGroupChannel.createMyGroupChannelListQuery()
            query?.includeEmptyChannel = true
            query?.loadNextPage(completionHandler: { (channels, error) in
                guard error == nil else {   // Error.
                    print("error grabbing channel list")
                    print(error)
                    return
                }
                self.myChannels = channels ?? [SBDGroupChannel]()
                self.tableView.reloadData()
            })
        })
    }

}

/*let ids = ["user1", "user2"]
 // Creates a group channel, delete this after one run
 SBDGroupChannel.createChannel(withUserIds: ids, isDistinct: true) { (channel, error) in
 guard error == nil else {   // Error.
 print("error creating channel")
 print(error)
 return
 }
 print("no error creating channel?")*/
//}
