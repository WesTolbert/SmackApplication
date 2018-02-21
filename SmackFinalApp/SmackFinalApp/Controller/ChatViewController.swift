//
//  ChatViewController.swift
//  SmackFinalApp
//
//  Created by Sonali Patel on 1/30/18.
//  Copyright © 2018 Sonali Patel. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    //Outlets
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var channelNameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.userDataDidChange(_notif:)), name: NOTIF_USER_DATA_DID_CHANGE , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.channelSelected(_notif:)), name: NOTIF_CHANNEL_SELECTED, object: nil)

        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail(completion: { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            })
        }
      //  MessageService.instance.findAllChannels { (success) in
            
       //}
    }
    @objc func userDataDidChange(_notif: Notification) {
        if AuthService.instance.isLoggedIn {
            // Get Channels
            onLoginGetMessages()
        } else {
            channelNameLbl.text = "Please Log In"
        }
    }
    
    @objc func channelSelected(_notif: Notification) {
        updateWithChannel()
    }
    
    func onLoginGetMessages() {
        MessageService.instance.findAllChannels { (success) in
            // Do stuff with channels
            if MessageService.instance.channels.count > 0 {
                MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                self.updateWithChannel()
            } else {
                self.channelNameLbl.text = "No Channels Yet"
            }
        }
    }
    
    func getMessages() {
        guard let channelID = MessageService.instance.selectedChannel?.id else { return }
        MessageService.instance.findAllMessagesForChannel(channelID: channelID) { (success) in
            
        }
    }
    
    func updateWithChannel() {
        let channelName = MessageService.instance.selectedChannel?.channelTitle ?? ""
        channelNameLbl.text = "#\(channelName)"
        getMessages()
    }

   

}
