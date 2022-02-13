  //
  //  ChatSupportController.swift
  //  FoodFox
  //
  //  Created by soc-macmini-30 on 26/09/17.
  //  Copyright © 2017 Click-Labs. All rights reserved.
  //

  import UIKit
//  import SDKDemo1
  //import MZFayeClient
 // import Hippo
  
  class ChatSupportController: UIViewController {
    
    //MARK: Outlet
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var tableview: UITableView!

    override func viewDidLoad() {
      super.viewDidLoad()
      self.navigationController?.navigationBar.isHidden = true
      tableview.registerCell(Identifier.chatCell)
      tableview.estimatedRowHeight = 100
      tableview.reloadData()
     }
    
    //MARK: Back Button Action
    @IBAction func backButton(_ sender: UIButton) {
      let language = Localize.currentLang()
      if language == .arabic {
        self.revealViewController().rightRevealToggle(animated: true)
        return
      }
        self.revealViewController().revealToggle(animated: true)
    }
    
    //MARK: Open Fugu Chat
    func openFuguChat() {
//      let manager = LoginManagerApi.share.me
//        
//        let hippoUserDetail = HippoUserDetail(fullName: manager?.fullName ?? "", email: manager?.email ?? "", phoneNumber: manager?.mobile ?? "", userUniqueKey: manager?.id ?? "")
//        HippoConfig.shared.updateUserDetail(userDetail: hippoUserDetail)
//        HippoConfig.shared.presentChatsViewController()
    }
  }

  //MARK: UITableView Delegate and Data Source
  extension ChatSupportController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return ChatType.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = tableview.dequeueReusableCell(withIdentifier: Identifier.chatCell) as? ChatSupportCell else {
        fatalError()
      }
      if let type = ChatType(rawValue: indexPath.row) {
       cell.titleImage.image = type.chatImage
       cell.titleLabel.text = type.titleChat
       cell.titleDescription.text = type.descriptionChat
      }
      return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     openFuguChat()
    }
  }
