//
//  ChatMainViewController.swift
//  Project
//
//  Created by Apple on 06/09/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit
import PubNub

class ChatMainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    //    @IBOutlet weak var titleLbl: UILabel!
    //    @IBOutlet weak var shipmentIdLbl: UILabel!
    //    @IBOutlet weak var startLocationLbl: UILabel!
    
    var notificationModal = [MessageModel]()
    var notificationFilteredModal = [MessageModel]()
    
    var pubnumPublichKey = "pub-c-2e80d162-68ec-4005-b6ca-5b416c9b2b8a"
    var pubnubSubcribeKey = "sub-c-68fb6f54-bb01-11e7-bcea-b64ad28a6f98"
    var pubnumClient : PubNub!
    
    var historymessage = [MessageModel]()
    var chennalName = "22"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
        setStringWithLocalized()
        self.loadArr()
        self.initializeXib()
        self.setUpNavigation()
        SetNavigationcontroller()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        initialLoads()
        SetNavigationcontroller()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func initializeXib(){
        
        tableView.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationTableViewCell")
        
    }
    private func setStringWithLocalized(){
        
        //        titleLbl.text = Constants.string.history
        //        shipmentIdLbl.text = Constants.string.shipmentID
        //        startLocationLbl.text = Constants.string.startLocation
    }
    
    private func loadArr(){
        
       // notificationModal = [NotificationModal(name: "Susan", date: "9:00AM", message: "There is a accident at Jalan Loke Yew, Please change the route"),NotificationModal(name: "June", date: "14/05/2018 11:00PM", message: "My truck brake down at Jalan Gasing, Ask some one to other truck")]
        notificationFilteredModal = historymessage
    }
    
    private func setUpNavigation(){
        
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.delegate = self
        
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    func SetNavigationcontroller(){
        self.navigationController?.isNavigationBarHidden = false
        if #available(iOS 11.0, *) {
            
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationBar.barTintColor = UIColor.red
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            let newBackButton = UIBarButtonItem(image:  #imageLiteral(resourceName: "back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(sideMenu(sender:)))
            self.navigationItem.leftBarButtonItem = newBackButton
            
            let rightButton = UIBarButtonItem(image:  #imageLiteral(resourceName: "send"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(composeMessage(sender:)))
            self.navigationItem.rightBarButtonItem = rightButton

            
        } else {
            //Fallback on earlier versions
        }
        title = "Chat"
    }
    
}


// MARK:- Search Delegate

extension ChatMainViewController : UISearchControllerDelegate, UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //
        if searchText.isEmpty {
            notificationFilteredModal = historymessage
        } else {
            
            notificationFilteredModal = historymessage.filter({ (notificationList) -> Bool in
                
                return (notificationList.name?.contains(searchText))!
                //return productlist.name?.lowercased().contains(searchText.lowercased()) ?? false
            })
            
            
        }
        
        print("filter : \(notificationFilteredModal)")
        tableView.reloadData()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        
        print("dismiss")
        notificationFilteredModal = historymessage
        tableView.reloadData()
        
    }
    
    
    //    func didDismissSearchController(_ searchController: UISearchController) {
    //        print("dismiss")
    //
    //    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search button")
    }
    
}

// MARK:- Methods

extension ChatMainViewController {
    
    private func initialLoads() {
        configurePubNubClient()
        
        getHistoryFromChennal()//        setupNavSearch()
        //        self.viewSideMenu.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sideMenuAction)))
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
                    message?.name = anyDictionary["name"] as? String
                    
                    
                    messageArray.append(message!)
                    
                }
                self.historymessage = messageArray
                self.loadArr()
                self.tableView.reloadData()
                
            }else{
                status?.retry()
                
            }
        }
    }
    
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
    
    private func setupNavSearch(){
        
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
    }
    
    
    // MARK:- SideMenu Button Action
    
    @IBAction private func sideMenuAction(){
        
      //  self.drawerController?.openSide(.left)
        //        self.viewSideMenu.addPressAnimation()
    }
    
    @objc func sideMenu(sender: UIBarButtonItem) {
        
       // self.drawerController?.openSide(.left)
        
    }
    
    @objc func composeMessage(sender: UIBarButtonItem) {
        

     //   push(id: Storyboard.Ids.ChatComposeViewController, animation: true)
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

//MARK:- TABLEVIEW DELEGATE

extension ChatMainViewController : UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell") as! NotificationTableViewCell
        let timevalue =  converteTimeStamptoDate(timeStamp: notificationFilteredModal.last?.created_at ?? 0.00)
        tableCell.messageLbl.text = notificationFilteredModal.last?.message
        tableCell.timeLbl.text = timevalue
        tableCell.nameLbl.text = notificationFilteredModal.last?.name
        
        
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
    }
    
  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController")
        self.title = "2"
        self.navigationController?.pushViewController(vc!, animated: true)
        //        push(id: Storyboard.Ids.ShipmentDetailViewController, animation: true)
        
    }
    
    
}

extension ChatMainViewController : PNObjectEventListener {
    
}
