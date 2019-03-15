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

class MessageKitViewController: MessagesViewController, SBDChannelDelegate {
    
    
    
    // ...
    
    var delegateIdentifier : String!
    
    //var messages: [Message] = []
    var member: Member!
    
    var channelURL : String!
    //var messages = [String]()
    var messages = [Message]()
    var channel : SBDGroupChannel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(channelURL)
        
        getMessages()

        //TODO: how to get current user nickname
        member = Member(name: "bluemoon", color: .blue)
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
    
    func getMessages() {
        SBDGroupChannel.getWithUrl(channelURL) { (groupChannel, error) in
            guard error == nil else {   // Error.
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
            /*var a = groupChannel!.myRole
             var b = groupChannel!.myMemberState
             var ba = groupChannel!.myMutedState
             var c = groupChannel!.members
             var d = groupChannel!.memberCount
             var e = groupChannel!.joinedMemberCount
             */
            
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
                        let sender = thing.sender as! SBDUser
                        let myMsg = Message(member: Member(name: sender.nickname ?? "", color: UIColor.red), text: thing.message!, messageId: thing.requestId!)
                        //self.messages.append(thing.message!)
                        self.messages.append(myMsg)
                    }
                    else if item is SBDFileMessage {
                        // Do something when the received message is a FileMessage.
                        print("file")
                    }
                    else if item is SBDAdminMessage {
                        // Do something when the received message is an AdminMessage.
                        print("admin")
                        let thing = item as! SBDAdminMessage
                        let myMsg = Message(member: Member(name: "Admin", color: UIColor.red), text: thing.message!, messageId: "")
                        //self.messages.append(thing.message!)
                        self.messages.append(myMsg)
                    }
                }
                //self.tableView.reloadData()
            })
            
        }
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
            let myMsg = Message(member: Member(name: "Admin", color: UIColor.red), text: thing.message!, messageId: "")
            //self.messages.append(thing.message!)
            self.messages.append(myMsg)
        }
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
                return
            }
            
            // ...
        })
    }
}
