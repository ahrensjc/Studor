//
//  MessageKitViewController.swift
//  Studor
//
//  Created by James Ahrens on 2/24/19.
//  Copyright © 2019 James Ahrens. All rights reserved.
//

import Foundation
import UIKit
import MessageKit
import MessageInputBar
import SendBirdSDK
import Firebase

struct Member {
    let name: String
    let color: UIColor
}

struct Message {
    let member: Member
    let text: String
    let messageId: String
}

extension Message: MessageType {
    var sender: Sender {
        return Sender(id: member.name, displayName: member.name)
    }
    
    var sentDate: Date {
        return Date()
    }
    
    var kind: MessageKind {
        return .text(text)
    }
}

class MessageKitViewController: MessagesViewController, SBDChannelDelegate, invDelegate {
    
    
    
    // ...
    
    var delegateIdentifier : String!
    
    //var messages: [Message] = []
    var member: Member!
    
    var channelURL : String!
    var sendbirdID : String!
    //var nickname : String!
    var sendbirdUser : SBDUser!
    var messages = [Message]()
    var channel : SBDGroupChannel!
    
    let loadingView = UIView()
    let loadingLabel = UILabel()
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(channelURL)
        
        setLoadingScreen()
        getChannel()
        
        //getMessages()
        
        /*let ref = firebaseSingleton.db.collection("Users").document(Auth.auth().currentUser!.uid)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                print("stuff")""
            }
        }*/
        
        

        //TODO: how to get current user nickname
        member = Member(name: sendbirdUser.nickname ?? "", color: .blue)
        //member = Member(name: .randomName, color: .random)

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        SBDMain.add(self as SBDChannelDelegate, identifier: self.description)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getChannel() {
        SBDGroupChannel.getWithUrl(channelURL) { (groupChannel, error) in
            guard error == nil else {   // Error.
                print("error getting channel")
                print(error as Any)
                // TODO: print popover saying error
                
                self.messageInputBar.isUserInteractionEnabled = false
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
                return
            }
            
            self.channel = groupChannel
            
            if groupChannel!.isPublic {
                let button =  UIButton(type: .custom)
                button.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
                //button.backgroundColor = .red
                //button.titleLabel?.textColor = UIColor(red:0.581, green:0.088, blue:0.319, alpha:1.0)
                button.setTitleColor(UIColor(red:0.491, green:0.119, blue:0.212, alpha:1.0), for: .normal)
                button.setTitle(self.channel.name, for: .normal)
                button.addTarget(self, action: #selector(self.clickOnButton), for: .touchUpInside)
                self.navigationItem.titleView = button
            } else {
                self.navigationItem.title = self.channel.name
            }
            
            let keys = [self.sendbirdID]
            
            groupChannel!.getMetaData(withKeys: keys as? [String], completionHandler: { (metaData, error) in
                guard error == nil else {   // Error.
                    print("error getting channel metadata")
                    print(error as Any)
                    return
                }
                for data in metaData! {
                    if data.value as! String == "invited" {
                        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "inv") as? InvitationViewController {
                            if let navigator = self.navigationController {
                                viewController.delegate = self
                                navigator.pushViewController(viewController, animated: false)
                            }
                        }
                        
                        //let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        //let invViewController = storyBoard.instantiateViewController(withIdentifier: "inv") as! InvitationViewController
                        //invViewController.delegate = self
                        //self.present(invViewController, animated: false, completion: { })
                    } else {
                        self.getMessages()
                    }
                }
            })
        }
    }
    
    func getMessages() {
        /*SBDGroupChannel.getWithUrl(channelURL) { (groupChannel, error) in
            guard error == nil else {   // Error.
                print("error getting channel")
                print(error as Any)
                // TODO: print popover saying error
                
                self.messageInputBar.isUserInteractionEnabled = false
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
                return
            }
            
            
            /*// In case of accepting an invitation
             let autoAccept = false // If true, a user will automatically join a group channel with no choice of accepting and declining an invitation.
             SBDMain.setChannelInvitationPreferenceAutoAccept(autoAccept) { (error) in
             guard error == nil else {   // Error.
             return
             }
             
             let ids = [String]()
             // Creates a group channel, delete this after one run
             SBDGroupChannel.createChannel(withUserIds: ids, isDistinct: false) { (channel, error) in
             guard error == nil else {   // Error.
             print("error creating channel")
             print(error)
             return
             }
             print("no error creating channel?")
             
             
             
             }
             
             }*/
            
            /*let userIds = ["joe"]
             groupChannel!.inviteUserIds(userIds) { (error) in
             guard error == nil else {   // Error.
             print("error inviting users")
             return
             }
             
             print("invited users")
             // ...
             }*/
            
            
            //print(groupChannel)
            //self.messages.append(groupChannel?.lastMessage?.description ?? "no last message found")
            //self.tableView.reloadData()
            
            self.channel = groupChannel
            self.navigationItem.title = self.channel.name
            
            let keys = [self.sendbirdID]
            
            groupChannel!.getMetaData(withKeys: keys as? [String], completionHandler: { (metaData, error) in
                guard error == nil else {   // Error.
                    print("error getting channel metadata")
                    print(error as Any)
                    return
                }
                for data in metaData! {
                    if data.value as! String == "invited" {
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let invViewController = storyBoard.instantiateViewController(withIdentifier: "inv") as! InvitationViewController
                        invViewController.delegate = self
                        self.present(invViewController, animated: true, completion: {
                            print("ran this code")
                        })
                    }
                }
            })*/
            
            
            
            let previousMessageQuery = self.channel.createPreviousMessageListQuery()
            previousMessageQuery?.loadPreviousMessages(withLimit: 100, reverse: true, completionHandler: { (oldMessages, error) in
                guard error == nil else {   // Error.
                    return
                }
                
                for item in oldMessages ?? [SBDBaseMessage]() {
                    if item is SBDUserMessage {
                        let thing = item as! SBDUserMessage
                        let sender = thing.sender as! SBDUser
                        print(sender.userId)
                        print(firebaseSingleton.sendbirdUser?.userId)
                        if sender.userId == firebaseSingleton.sendbirdUser?.userId {
                            let myMsg = Message(member: Member(name: firebaseSingleton.sendbirdUser?.nickname ?? "empty nickname", color: UIColor.blue), text: thing.message!, messageId: thing.requestId!)
                            self.messages.append(myMsg)
                        } else {
                            let myMsg = Message(member: Member(name: sender.nickname ?? "", color: UIColor.red), text: thing.message!, messageId: thing.requestId!)
                            self.messages.append(myMsg)
                        }
                    }
                    else if item is SBDFileMessage {
                        // Do something when the received message is a FileMessage.
                    }
                    else if item is SBDAdminMessage {
                        let thing = item as! SBDAdminMessage
                        let myMsg = Message(member: Member(name: "Admin", color: UIColor(red:0.491, green:0.119, blue:0.212, alpha:1.0)), text: thing.message!, messageId: "")
                        self.messages.append(myMsg)
                    }
                }
                //self.tableView.reloadData()
                self.messages.reverse()
                self.removeLoadingScreen()
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToBottom(animated: true)
            })
            
        //}
    }

    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        if message is SBDUserMessage {
            // Do something when the received message is a UserMessage.
            let thing = message as! SBDUserMessage
            let sender = thing.sender as! SBDUser
            let myMsg = Message(member: Member(name: sender.nickname ?? "", color: UIColor.red), text: thing.message!, messageId: thing.requestId!)
            //self.messages.append(thing.message!)
            self.messages.append(myMsg)
        }
        else if message is SBDFileMessage {
            // Do something when the received message is a FileMessage.
        }
        else if message is SBDAdminMessage {
            // Do something when the received message is an AdminMessage.
            let thing = message as! SBDAdminMessage
            let myMsg = Message(member: Member(name: "Admin", color: UIColor(red:0.491, green:0.119, blue:0.212, alpha:1.0)), text: thing.message!, messageId: "")
            //self.messages.append(thing.message!)
            self.messages.append(myMsg)
        }
        self.messagesCollectionView.reloadData()
        self.messagesCollectionView.scrollToBottom(animated: true)
    }
    
    func declined(child: InvitationViewController) {
        child.dismiss(animated: false, completion: nil)
        channel.leave { (error) in
            guard error == nil else {   // Error.
                print("error leaving channel")
                print(error as Any)
                return
            }
            print("left channel")
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: false)
            }
        }
    }
    
    func accepted(child: InvitationViewController) {
        child.dismiss(animated: false, completion: nil)
        getMessages()
        let metaDataToUpdate = [sendbirdID:"accepted"]
        
        channel?.updateMetaData(metaDataToUpdate as! [String : String], completionHandler: { (metaData, error) in
            guard error == nil else {   // Error.
                return
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is InvitationViewController {
            let child = segue.destination as! InvitationViewController
            child.delegate = self
        }
    }
    
    @objc func clickOnButton() {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "groupProfile") as? ViewGroupProfileViewController {
            viewController.channelUrl = channelURL
            //viewController.channelName = channel.name
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    // Set the activity indicator into the main view
    private func setLoadingScreen() {
        
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (view.frame.width / 2) - (width / 2)
        let y = (view.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
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
        activityIndicator.tintColor = UIColor(red:0.491, green:0.119, blue:0.212, alpha:1.0)
        activityIndicator.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(activityIndicator)
        loadingView.addSubview(loadingLabel)
        
        view.addSubview(loadingView)
    }
    
    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {
        
        // Hides and stops the text and the spinner
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        loadingLabel.isHidden = true
    }
}

extension MessageKitViewController: MessagesDataSource {
    func numberOfSections(
        in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func currentSender() -> Sender {
        return Sender(id: member.name, displayName: member.name)
    }
    
    func messageForItem(
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return messages[indexPath.section]
    }
    
    func messageTopLabelHeight(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 12
    }
    
    func messageTopLabelAttributedText(
        for message: MessageType,
        at indexPath: IndexPath) -> NSAttributedString? {
        
        return NSAttributedString(
            string: message.sender.displayName,
            attributes: [.font: UIFont.systemFont(ofSize: 12)])
    }
}

extension MessageKitViewController: MessagesLayoutDelegate {
    func heightForLocation(message: MessageType,
                           at indexPath: IndexPath,
                           with maxWidth: CGFloat,
                           in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 0
    }
}

extension MessageKitViewController: MessagesDisplayDelegate {
    func configureAvatarView(
        _ avatarView: AvatarView,
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) {
        
        let message = messages[indexPath.section]
        let color = message.member.color
        avatarView.backgroundColor = color
    }
}

extension MessageKitViewController: MessageInputBarDelegate {
    func messageInputBar(
        _ inputBar: MessageInputBar,
        didPressSendButtonWith text: String) {
        
        let newMessage = Message(
            member: member,
            text: text,
            messageId: UUID().uuidString)
        
        messages.append(newMessage)
        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
        
        channel.sendUserMessage(text, data: nil, completionHandler: { (userMessage, error) in
            guard error == nil else {   // Error.
                print("failure sending message")
                print(error as Any)
                return
            }
            
            // ...
        })
    }
}
