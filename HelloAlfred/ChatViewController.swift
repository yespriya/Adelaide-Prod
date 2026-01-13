//
//  ChatViewController.swift
//  Midjo Driver
//
//  Created by admin on 8/19/23.

import UIKit
import MessageKit
import MessageUI
import InputBarAccessoryView

import Foundation

struct Messages:MessageType {
    var sentDate: Date
    var kind: MessageKind
    var sender: SenderType
    var messageId: String
}
struct Sender:SenderType{
    var senderId: String
    var displayName: String
}

class ChatViewController: MessagesViewController,MessagesDataSource,MessagesLayoutDelegate,MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
    func currentSender() -> MessageKit.SenderType {
        return currentUser

    }
    
   
    
    var viewModel = ChatViewModel()

//    var currentSender : MessageKit.SenderType{
//        return currentUser
//    }
    let currentUser = Sender(senderId: "User", displayName: "Richard:")
    let currentUserImage = UIImage(named: "ic_nousericon")
    
    let AdminUser = Sender(senderId: "Admin", displayName: "Alfred :")
    let otherUserImage = UIImage(named: "ic_Admin_User")
    
    var currentUserAvatar: Avatar?
    var otherUserAvatar: Avatar?
    
    var messages = [MessageType]()
    var MessagesArray: NSMutableArray = []
    var messageCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
         currentUserAvatar = Avatar(image: currentUserImage, initials: "")
         otherUserAvatar = Avatar(image: otherUserImage, initials: "")
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
//        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
//          layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
//            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
//            layout.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)))
//            
//        }
        messageInputBar.delegate = self
        messageInputBar.backgroundView.backgroundColor = UIColor.white
//        messageInputBar.leftStackView.leftAnchor = 20
        messageInputBar.setLeftStackViewWidthConstant(to: 10, animated: false)
        messageInputBar.setRightStackViewWidthConstant(to: 50, animated: false)
        messageInputBar.inputTextView.layer.cornerRadius = 20
        messageInputBar.inputTextView.layer.borderColor = UIColor(red: 0.87, green: 0.89, blue: 0.92, alpha: 1.00).cgColor
        messageInputBar.inputTextView.placeholder = "Type a message..."
        messageInputBar.inputTextView.layer.borderWidth = 1
        messageInputBar.leftStackView.alignment = .center //HERE
        messageInputBar.rightStackView.alignment = .center //HERE
        if let iconImage = UIImage(named: "chathide_icon") {
                   // Create a UIBarButtonItem with the icon image
            let iconBarButtonItem = UIBarButtonItem(image: iconImage, style: .plain, target: self, action: #selector(buttonAction(_:)))
            iconBarButtonItem.tintColor = .clear
            navigationItem.leftBarButtonItem = iconBarButtonItem
        }
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
  
    override func viewWillAppear(_ animated: Bool) {
        let initial = Messages(sentDate: Date(), kind: .text("Good Morning Mr. Richard. This is ALFRED your virtual chat assistant . How can I help you"), sender: AdminUser, messageId: "\(messageCount)")
        messages.append(initial)
        messageCount = messages.count
        messagesCollectionView.reloadData()
        messagesCollectionView.backgroundColor = UIColor.HexToColor(hexString: "#F3F5FC")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        messagesCollectionView.contentInset.top = 10
        messagesCollectionView.contentInset.bottom = -10
    }
    
    @objc func buttonAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    //Date to milliseconds
    func currentTimeInMiliseconds() -> Int! {
        let currentDate = NSDate()
        let dateFormatter = DateFormatter()
        let date = dateFormatter.date(from: dateFormatter.string(from: currentDate as Date))
        let nowDouble = date!.timeIntervalSince1970
        return Int(nowDouble)
    }
 
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        print(text)
        getUpdateAIText(text: text)
        let initial = Messages(sentDate: Date(), kind: .text(text), sender: currentSender(), messageId: "\(messageCount)")
        messages.append(initial)
        messageCount = messages.count
        messagesCollectionView.reloadData()
        self.messagesCollectionView.scrollToLastItem()
        inputBar.inputTextView.resignFirstResponder()
        inputBar.inputTextView.text = ""
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {
        
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didSwipeTextViewWith gesture: UISwipeGestureRecognizer) {
        
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 21
    }
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        let formatter = DateFormatter()
        // "Oct 8, 2016, 10:52:30 PM"
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        formatter.dateFormat = "MMM d, yyyy, HH:mm a"
       let someDateTime = formatter.string(from: message.sentDate)
        
//        if  isFromCurrentSender(message: message) {
        let message = "\(someDateTime)"
        return NSAttributedString(string: message, attributes: [.font : UIFont.boldSystemFont(ofSize: 10), .foregroundColor : UIColor.darkGray] )
//        }
//        return nil
        
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor.white : UIColor(red: 0.12, green: 0.64, blue: 0.58, alpha: 1.00)
    }
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor.black: UIColor.white
    }
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at _: IndexPath, in _: MessagesCollectionView) {
        let avatar = isFromCurrentSender(message: message) ? currentUserAvatar: otherUserAvatar
        avatarView.set(avatar: avatar!)
    }
    
}

extension ChatViewController {
    //MARK: - Webservices
    func getUpdateAIText(text:String){
        let parameters = "{\"max_tokens\": 800, \"messages\": [{\"role\": \"user\", \"content\": \"\(text)\"}]}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://hai1.openai.azure.com/openai/deployments/HA_Test/chat/completions?api-version=2023-07-01-preview")!, timeoutInterval: Double.infinity)
        request.addValue("d1a9d04651ec4405a1ce74ffaa8a7b57", forHTTPHeaderField: "api-key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            guard let data = data else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status code: \(httpResponse.statusCode)")
            }
            
            if let responseData = String(data: data, encoding: .utf8) {
                print("Response data: \(responseData)")
                do {
                    let decoder = JSONDecoder()
                    let myData = try decoder.decode(ChatModel.self, from: data)
                    print(myData)
                    self.viewModel.chatFetchStatus = myData
                } catch {
                    print("Error decoding JSON: \(error)")
                }

                print("\(self.viewModel.chatFetchStatus?.choices?[0].message!.content! ?? "HAi")")
                let initial = Messages(sentDate: Date(), kind: .text("\(self.viewModel.chatFetchStatus?.choices?[0].message!.content! ?? "Hai")"), sender: AdminUser, messageId: "\(messageCount)")
                messages.append(initial)
                messageCount = messages.count
               }
            print(messages)
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem()
            }

        }
        task.resume()

    }
}
