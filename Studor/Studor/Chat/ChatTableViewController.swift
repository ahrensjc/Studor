//
//  ChatTableViewController.swift
//  Studor
//
//  Created by James Ahrens on 2/8/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import UIKit
import SendBirdSDK

class ChatTableViewController: UITableViewController {
    
    var channelURL : String!
    var messages = [String]()
    var channel : SBDGroupChannel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(channelURL)
        
        getMessages()
        print("WHAT")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatTableViewCell

        // Configure the cell...
        cell.chatLabel.text = messages[indexPath.item]

        return cell
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
    
    func getMessages() {
        SBDGroupChannel.getWithUrl(channelURL) { (groupChannel, error) in
            guard error == nil else {   // Error.
                return
            }
            
            //print(groupChannel)
            //self.messages.append(groupChannel?.lastMessage?.description ?? "no last message found")
            //self.tableView.reloadData()

            self.channel = groupChannel
            
            /*let msg = "lovely weather today"
            
            self.channel.sendUserMessage(msg, data: nil, completionHandler: { (userMessage, error) in
                guard error == nil else {   // Error.
                    return
                }
                
                // ...
            })*/
            
            let previousMessageQuery = self.channel.createPreviousMessageListQuery()
            previousMessageQuery?.loadPreviousMessages(withLimit: 30, reverse: true, completionHandler: { (oldMessages, error) in
                guard error == nil else {   // Error.
                    return
                }
                
                // ..
                
                for item in oldMessages ?? [SBDBaseMessage]() {
                    
                    if item is SBDUserMessage {
                        // Do something when the received message is a UserMessage.
                        print("user")
                        let thing = item as! SBDUserMessage
                        self.messages.append(thing.message!)
                    }
                    else if item is SBDFileMessage {
                        // Do something when the received message is a FileMessage.
                        print("file")
                    }
                    else if item is SBDAdminMessage {
                        // Do something when the received message is an AdminMessage.
                        print("admin")
                        let thing = item as! SBDAdminMessage
                        self.messages.append(thing.message!)
                    }
                }
                self.tableView.reloadData()
            })
            
        }
    }

}
