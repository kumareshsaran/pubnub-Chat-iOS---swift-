//
//  ViewController.swift
//  PubnubChat
//
//  Created by CSS on 05/09/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit
import PubNub

class ViewController: UIViewController {

    @IBOutlet var chatTableView: UITableView!
    @IBOutlet var viewBottonAnchore: NSLayoutConstraint!
    var pubnumClient : PubNub!
    
    @IBOutlet var textViewBottomConstrant: NSLayoutConstraint!
    @IBOutlet var textview: UITextView!
    @IBOutlet var buttonSend: UIButton!
    var pubnumPublichKey = "pub-c-2e80d162-68ec-4005-b6ca-5b416c9b2b8a"
    var pubnubSubcribeKey = "sub-c-68fb6f54-bb01-11e7-bcea-b64ad28a6f98"
    
    var cellId = "1234"
    var chennalName = "22"   //ChatChennal
    @IBOutlet var textfieldBottomConstrain: NSLayoutConstraint!
    
    @IBOutlet var sendwidthAnchore: NSLayoutConstraint!
    var message = MessageModel()
    var historymessage = [MessageModel]()
    var messageDic : [String: Any]?
   // var messageArray = [MessageModel(text: "naucgygasgdfuyegdbasgctfevhsgdvghfsdhvfh", id: 1, isIncomming: true),MessageModel(text: "naucgygasgdfuyegdbasgctfevhsgdvghfsdhvfhnaucgygasgdfuyegdbasgctfevhsgdvghfsdhvfh", id: 3, isIncomming: true),MessageModel(text: "hsdifhdsh", id: 4, isIncomming: false), MessageModel(text: "hdsbbsjdhbvh bsnd  csn dbcshdgc sdc sdchbsdc", id: 4, isIncomming: false), MessageModel(text: "hdsdc", id: 4, isIncomming: false)]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initialLoad()
    }
    
    
    override func viewDidLayoutSubviews() {
        self.textview.layer.cornerRadius = 15
    }



}

extension ViewController {
    
    private func initialLoad(){
        
        self.sendwidthAnchore.constant = 0
        self.view.layoutIfNeeded()
        print("currentTime stamp: \(time)")
        
        setNavigationBar()
        self.configurePubNubClient()
        self.checkConnnectivity()
      //  sendMessage()
        getHistoryFromChennal()
        keyboardObserver()
        chatTableView.register( ChatTableViewCell.self , forCellReuseIdentifier: cellId)
        
        self.buttonSend.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.scrollToBottom()
//        }
        
        
    }
    
    private func keyboardObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardwillshow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func keyBoardwillshow(info: NSNotification){
        guard let keyboard = (info.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        print(keyboard.height)
        self.viewBottonAnchore.constant = (keyboard.height)
       
        self.view.layoutIfNeeded()
        
    }
    
    @IBAction func keyboardWillHide(info: NSNotification){
        guard let keyboard = (info.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        print(keyboard.height)
        self.viewBottonAnchore.constant = 0
        self.view.layoutIfNeeded()
    }
    
    
    private func setNavigationBar(){
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(back) )
        title = "Message"
    }
    
    @objc func back(){
        
    }
    
    
    //MARK:- Configure the pubnum client to our chat channel.. Chat chennal is created in admin.pubnum.com.
    private func configurePubNubClient(){
        let configure = PNConfiguration(publishKey: pubnumPublichKey, subscribeKey: pubnubSubcribeKey)
        self.pubnumClient = PubNub.clientWithConfiguration(configure)
        self.pubnumClient.addListener(self)
        
        self.pubnumClient.subscribeToChannels([chennalName], withPresence: true)
    }
    //MARK:- Check our chennal is connected to pubnub server or not.
    private func checkConnnectivity(){
        self.pubnumClient.timeWithCompletion { (result, error) in
            if error != nil{
                
            }
            print("result: \(result?.data)")
        
        }
    }
    
    
    @IBAction private func sendMessage(){
       // let message = [MessageModel(text: self.textview.text ?? "", id: 0, isIncomming: true)]
        
        
        //print("messahes: \(message)")
        let timestamp = NSDate().timeIntervalSince1970
        message.message = "\(self.textview.text ?? "")"
        message.type = "driver"
        message.created_at = timestamp
        message.name = "Kumaresan"
        
        //let messageDic = ["text": self.textview.text ?? "", "isIncomming": true] as [String : Any]
//        if messageDic?.count ?? 0 % 2 == 0{
//            messageDic?.updateValue(self.textview.text, forKey: "text")
//            messageDic?.updateValue(true, forKey: "isIncomming")
//        }else{
//            messageDic?.updateValue(self.textview.text, forKey: "text")
//            messageDic?.updateValue(false, forKey: "isIncomming")
//        }
        
       self.textview.text = ""
        self.pubnumClient.publish( message.JSONRepresentation , toChannel: chennalName) { (status) in
            if status.isError{
                
            }else{
                print(status)
            }
        }
        
    }
    
    
    private func getHistoryFromChennal(){
        
        
        
        
        self.pubnumClient.historyForChannel(chennalName) { (result, status) in
            if status == nil {
                print(result?.data.messages)
                var message : MessageModel?
                var messageArray = [MessageModel]()
                for anyMessage in (result?.data.messages ?? [])  where anyMessage is NSDictionary {
                    message = MessageModel()
                    let anyDictionary = anyMessage as! NSDictionary
                    message?.created_at = anyDictionary["created_at"] as? Double
                    message?.type = anyDictionary["type"] as? String
                    message?.message = anyDictionary["message"] as? String
                    
                    
                    messageArray.append(message!)
                    
                }
                self.historymessage = messageArray
                self.chatTableView.reloadData()
                
            }else{
                 status?.retry()
                
            }
        }
    }
    
    func relativePast(for date : Date?) -> String {
        
//        guard let date = date else {
//            return .Empty
//        }
        
        let units = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second, .weekOfYear])
        let components = Calendar.current.dateComponents(units, from: date!, to: Date())
        
        if components.year! > 0 {
            return "\(components.year!) " + (components.year! > 1 ? "years ago" : "year ago")
            
        } else if components.month! > 0 {
            return "\(components.month!) " + (components.month! > 1 ? "months ago" : "month ago")
            
        } else if components.weekOfYear! > 0 {
            return "\(components.weekOfYear!) " + (components.weekOfYear! > 1 ? "weeks ago" : "week ago")
            
        } else if (components.day! > 0) {
            return (components.day! > 1 ? "\(components.day!) days ago" : "Yesterday")
            
        } else if components.hour! > 0 {
            return "\(components.hour!) " + (components.hour! > 1 ? "hours ago" : "hour ago")
            
        } else if components.minute! > 0 {
            return "\(components.minute!) " + (components.minute! > 1 ? "minutes ago" : "minute ago")
            
        } else {
            return "\(components.second!) " + (components.second! > 1 ? "seconds ago" : "second ago")
        }
    }
    
    func converteTimeStamptoDate(timeStamp : Double)-> String{
        
        let date = NSDate(timeIntervalSince1970: timeStamp)
        
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "hh:mm a"//"dd MMM YY, hh:mm a"
        // UnComment below to get only time
        //  dayTimePeriodFormatter.dateFormat = "hh:mm a"
        
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
    
}

extension ViewController : PNObjectEventListener {
    
    func client(_ client: PubNub, didReceive status: PNStatus) {
        print(status)
    }
    
    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        print("Recevied message: \(message.data.message) on chennal \(message.data.channel)")
        var newmessage = NSDictionary()
        var messag = MessageModel()
        newmessage = message.data.message as! NSDictionary
        messag.created_at = newmessage["created_at"] as? Double
        messag.message = newmessage["message"] as? String
        messag.type = newmessage["type"] as? String
        
        self.historymessage.append(messag)
        
        self.chatTableView.insertRows(at: [IndexPath(row: (self.historymessage.count) - 1, section: 0)], with: .automatic)
        
        
        scrollToBottom()
        
       // self.getHistoryFromChennal()
        
        //getHistoryFromChennal()
    }
    
    func client(_ client: PubNub, didReceivePresenceEvent event: PNPresenceEventResult) {
        if event.data.channel != event.data.subscription {
            
            // Presence event has been received on channel group stored in event.data.subscription.
        }
        else {
            
            // Presence event has been received on channel stored in event.data.channel.
        }
        
        if event.data.presenceEvent != "state-change" {
            
            print("\(event.data.presence.uuid) \"\(event.data.presenceEvent)'ed\"\n" +
                "at: \(event.data.presence.timetoken) on \(event.data.channel) " +
                "(Occupancy: \(event.data.presence.occupancy))");
        }
        else {
            
            print("\(event.data.presence.uuid) changed state at: " +
                "\(event.data.presence.timetoken) on \(event.data.channel) to:\n" +
                "\(event.data.presence.state)");
        }
    }
    
    
    
    
    func scrollToBottom(){
        if self.historymessage.count > 0 {
            self.chatTableView.scrollToRow(at: IndexPath(row: (self.historymessage.count) - 1, section: 0), at: .bottom, animated: true)
        }
        
    }

    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if historymessage != nil {
            return (historymessage.count)
        }
        return 0
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatTableViewCell
        
       let timevalue =  converteTimeStamptoDate(timeStamp: historymessage[indexPath.row].created_at ?? 0.00)
        cell.selectionStyle = .none
        print("historymessage: \(historymessage[indexPath.row].message),time: \(timevalue)")
        cell.labelMessage.text = historymessage[indexPath.row].message
        cell.isIncomming =  historymessage[indexPath.row].type ?? ""
        cell.labelTime.text = timevalue
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.textview.resignFirstResponder()

    }
    
    
    
    
    
    
    
}

extension ViewController : UITextViewDelegate{

    
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollToBottom()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let str = self.textview.text
        let trimmed = str?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        print("trimmed: \(trimmed)")
        
        if trimmed == ""{
            UIView.animate(withDuration: 0.5, animations: {
                self.sendwidthAnchore.constant = 0
                self.view.layoutIfNeeded()
            })
        }else{
            UIView.animate(withDuration: 0.6, animations: {
                self.sendwidthAnchore.constant = 50
                self.view.layoutIfNeeded()
            })
        }
//            if textView.text.isEmpty {
//
//            }else{
//
//            }

            
       
     }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    
       
    }

