  //
  //  TrackOrderViewController.swift
  //  FoodFox
  //
  //  Created by clicklabs on 13/12/17.
  //  Copyright © 2017 Click-Labs. All rights reserved.
  //

  import UIKit
//  import SDKDemo1
  //import MZFayeClient

  class TrackOrderViewController: UIViewController {
    
    //MARK: Outlet
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var statusTrackingLbl: UILabel! {
        didSet {
            statusTrackingLbl.font =  AppFont.bold(size: 22)
        }
    }
    
    @IBOutlet weak var time: UILabel! {
        didSet {
            time.font =  AppFont.semiBold(size: 17)
        }
    }
    @IBOutlet weak var orderId: UILabel! {
        didSet {
            orderId.font =  AppFont.semiBold(size: 17)
        }
    }
    @IBOutlet weak var trackOrder: UIButton! {
        didSet {
            trackOrder.titleLabel?.font =  AppFont.semiBold(size: 18)
        }
    }
    @IBOutlet weak var tableViewheight: NSLayoutConstraint!
    @IBOutlet weak var btnClose: UIButton! {
        didSet {
            btnClose.titleLabel?.font =  AppFont.semiBold(size: 18)
        }
    }
    @IBOutlet weak var navTitle: UILabel! {
        didSet {
            navTitle.font =  AppFont.semiBold(size: 20)
        }
    }
    @IBOutlet weak var countDownLabel: UILabel! {
        didSet {
            countDownLabel.font =  AppFont.regular(size: 17)
        }
    }
    @IBOutlet weak var orderNumberLbl: UILabel! {
        didSet {
            orderNumberLbl.font =  AppFont.regular(size: 17)
        }
    }
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var timeImageView: UIImageView!
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var orderStatusView: UIView!
    
    //MARK: Var
    var trackData: TrackOrderModel?
    var bookingId = ""
    var timer: Timer?
    var countDownTimer: Timer?
    private let refreshControl = UIRefreshControl()
    fileprivate var orderStatus: Status = .unAssigned
    
    //MARK: View Did load
    override func viewDidLoad() {
      super.viewDidLoad()
       addTimer()
      self.setUpTable()
      trackOrder.isHidden = true
      tableViewheight.constant = 0
      self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
      localizedString()
      }
    
    //MARK: Add Timer to check Left timer
    /// - added timer to controlling and checking the
    /// - booking delivery time left or not
    func addTimer() {
     countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(TrackOrderViewController.setTimeLeft)), userInfo: nil, repeats: true)
     timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: (#selector(TrackOrderViewController.getTrackingData)), userInfo: nil, repeats: true)
    }
    
    //MARK: Localized String
    func localizedString() {
     navTitle.text = "Track Order".localizedString
        
        statusTrackingLbl.text = "STATUS TRACKING".localizedString
     //btnClose.setTitle("CLOSE".localizedString, for: .normal)
     countDownLabel.text = "Count Down".localizedString
     orderNumberLbl.text = "Order Number".localizedString
    }
    
    //MARK: View will appear
    override func viewWillAppear(_ animated: Bool) {
      self.getTrackingData()
      setUpReferece()
      checkStausForDarkMode( )
    }
    
    
    
    func checkStausForDarkMode( ) {
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            self.topView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            self.navTitle.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.tableView.backgroundColor  = #colorLiteral(red: 0.1926900744, green: 0.1959174871, blue: 0.2002623975, alpha: 1)
            self.countDownLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.statusTrackingLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.orderNumberLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.orderStatusView.backgroundColor = #colorLiteral(red: 0.1926900744, green: 0.1959174871, blue: 0.2002623975, alpha: 1)
            self.refreshControl.backgroundColor = #colorLiteral(red: 0.1926900744, green: 0.1959174871, blue: 0.2002623975, alpha: 1)
            self.view.backgroundColor = #colorLiteral(red: 0.1926900744, green: 0.1959174871, blue: 0.2002623975, alpha: 1)
            self.timeImageView.image = UIImage(named: "timew")
            btnClose.setImage(UIImage(named: "cancel"), for: .normal)
            
        } else {
            self.topView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
             self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.refreshControl.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.tableView.backgroundColor  = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.navTitle.textColor = #colorLiteral(red: 0.1926900744, green: 0.1959174871, blue: 0.2002623975, alpha: 1)
            self.countDownLabel.textColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.statusTrackingLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.orderNumberLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.orderStatusView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
             btnClose.setImage(#imageLiteral(resourceName: "cancel-1"), for: .normal)
            self.timeImageView.image = UIImage(named: "time")
        }
    }
    
    //MARK: view did Disappear
    override func viewDidDisappear(_ animated: Bool) {
      timer?.invalidate()
      timer = nil
      countDownTimer?.invalidate()
      countDownTimer = nil
    }
    
      //MARK: SetUpReferece TableView
      func setUpReferece() {
          if #available(iOS 10.0, *) {
              tableView.refreshControl = refreshControl
          } else {
              tableView.addSubview(refreshControl)
          }
          refreshControl.tintColor = darkPinkColor
          refreshControl.backgroundColor = whiteColor
          let value = "Updating Booking Status...".localizedString
        let string = NSMutableAttributedString(string: value, attributes: [NSAttributedString.Key.foregroundColor: darkPinkColor, NSAttributedString.Key.font: UIFont(name: fontNameRegular, size: 14) ?? UIFont.systemFont(ofSize: 15)])
          refreshControl.attributedTitle = NSAttributedString(attributedString: string)
          refreshControl.addTarget(self, action: #selector(refreshBookingData), for: .valueChanged)
      }
    
      //MARK: Refresh Booking Data
      @objc func refreshBookingData() {
          getTrackingData()
          self.refreshControl.endRefreshing()
      }
    
    //MARK: Get Tracking Data
    @objc func getTrackingData() {
      TrackOrderModel.orderTrack(bookingId: bookingId, callBack: {(data: TrackOrderModel?, error: Error?) in
           if error == nil {
            self.trackData = data
            self.bookingType()
            self.setupUI()
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
           }
        })
    }
    
    //MARK: Setup UI with Response
    func setupUI() {
      if let id  = self.trackData?.orderId {
        self.orderId.text = "\(id)"
      }
    }
    
    //MARK: Setup Table view
    func setUpTable() {
      tableView.registerCell(Identifier.trackTableViewCell)
      tableView.estimatedRowHeight = 100
    }
    
    
    //MARK: Back to previous controller
    @IBAction func closeButtonAction(_ sender: UIButton) {
      self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Track Button Action
    @IBAction func trackOrderAction(_ sender: UIButton) {
      if bookingFlow == .pickup {
        guard let chatVc = R.storyboard.home.liveZillaChatVc() else {
            return
        }
        self.present(chatVc, animated: true, completion: nil)
        return
//        let manager = LoginManagerApi.share.me
//        let fuguUserDetail = FuguUserDetail(fullName: manager?.fullName ?? "", email: manager?.email ?? "", phoneNumber: manager?.mobile ?? "", userUniqueKey: manager?.id ?? "")
//        FuguConfig.shared.updateUserDetail(userDetail: fuguUserDetail)
//        FuguConfig.shared.presentChatsViewController()
//        return
      }
      
      guard let vc = self.storyboard?.instantiateViewController(withIdentifier: Identifier.trackOrderMapViewController) as? TrackOrderMapViewController else {
        return
      }
      vc.bookingId = self.bookingId
      if let id = self.trackData?.orderId {
      vc.orderId = "\(id)"
      }
      self.navigationController?.pushViewController(vc, animated: true)
    }
   
    //MARK: SetUp Booking Flow
    func bookingType() {
      guard let  type = self.trackData?.bookingType else {
        return
      }
      if type == 2 {
        bookingFlow = .home
      } else if type == 1 {
        bookingFlow = .pickup
      }
    }
  }

  // MARK: TableView Delegate and DataSource
  /// -Show Tracking Status of Driver For PickUp and Delivery
  /// 
  extension TrackOrderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return OrderStatus.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      guard let sectionType = OrderStatus(rawValue: indexPath.row) else {
        fatalError()
      }
       // print("sectionType", sectionType)
      if sectionType == .unknown {
        print("sectionType unknown")
        return 50
      }
      return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      guard let sectionType = OrderStatus(rawValue: indexPath.row) else {
        fatalError()
      }
      
        
        
        
      if sectionType == .unknown {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            cell.contentView.backgroundColor = #colorLiteral(red: 0.1926900744, green: 0.1959174871, blue: 0.2002623975, alpha: 1)
            cell.backgroundColor = #colorLiteral(red: 0.1926900744, green: 0.1959174871, blue: 0.2002623975, alpha: 1)
            cell.backgroundView?.backgroundColor = #colorLiteral(red: 0.1926900744, green: 0.1959174871, blue: 0.2002623975, alpha: 1)
            
            
            
        } else {
            cell.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.backgroundView?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
       
        return cell
      }
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.trackTableViewCell) as? TrackTableViewCell else {
        fatalError("Could not load nib TrackTableViewCell")
      }
        
        
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            cell.contentView.backgroundColor = #colorLiteral(red: 0.1926900744, green: 0.1959174871, blue: 0.2002623975, alpha: 1)
            cell.backgroundColor = #colorLiteral(red: 0.1926900744, green: 0.1959174871, blue: 0.2002623975, alpha: 1)
            cell.backgroundView?.backgroundColor = #colorLiteral(red: 0.1926900744, green: 0.1959174871, blue: 0.2002623975, alpha: 1)
            cell.statusName.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.statusDescription.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.statusTime.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.statusTrackingLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            //  trackOrder.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            
            
        } else {
            cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.backgroundView?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.statusName.textColor = #colorLiteral(red: 0.1926900744, green: 0.1959174871, blue: 0.2002623975, alpha: 1)
            cell.statusDescription.textColor = #colorLiteral(red: 0.1926900744, green: 0.1959174871, blue: 0.2002623975, alpha: 1)
            cell.statusTime.textColor = #colorLiteral(red: 0.1926900744, green: 0.1959174871, blue: 0.2002623975, alpha: 1)
            self.statusTrackingLbl.textColor = #colorLiteral(red: 0.1926900744, green: 0.1959174871, blue: 0.2002623975, alpha: 1)
           // trackOrder.setTitleColor(#colorLiteral(red: 0.1926900744, green: 0.1959174871, blue: 0.2002623975, alpha: 1), for: .normal)
           
        }
        
      cell.trackImage.image = sectionType.selectedImage
      cell.statusName.text = sectionType.statusName.localizedString
      cell.statusDescription.text = sectionType.statusDescription.localizedString
      
      guard let trackValue = trackData?.tokanStatusJob else {
        fatalError()
      }
      guard let type = Status(rawValue: trackValue) else {
        fatalError()
      }
      self.orderStatus = type
      if bookingFlow == .pickup {
       trackOrder.setTitle("NEED HELP?".localizedString, for: .normal)
       trackOrder.isHidden = true  //false
       tableViewheight.constant = 50
      } else {
        trackOrder.setTitle("TRACK NOW".localizedString, for: .normal)
        trackOrder.isHidden = true
        tableViewheight.constant = 0
      }
        
        if sectionType.statusName == "Order Placed" {
            
//            if type == .unAssigned{
//                if indexPath.row < type.value && (trackData?.status == type.backendStatus) {
//                     cell.lineView.backgroundColor = #colorLiteral(red: 0.767647922, green: 0.05847137421, blue: 0.2396849394, alpha: 1)
//                     cell.circleView.backgroundColor = #colorLiteral(red: 0.767647922, green: 0.05847137421, blue: 0.2396849394, alpha: 1)
//                     cell.blurView.alpha = 0
//                }
//                
//                if indexPath.row < 3 && (trackData?.status == Driver.driverFailed.rawValue) {   // 16 for driver unAssigned
//                     cell.lineView.backgroundColor = #colorLiteral(red: 0.767647922, green: 0.05847137421, blue: 0.2396849394, alpha: 1)
//                     cell.circleView.backgroundColor = #colorLiteral(red: 0.767647922, green: 0.05847137421, blue: 0.2396849394, alpha: 1)
//                     cell.blurView.alpha = 0
//                }
//            }
            if (trackData?.bookingDateTime != "" && trackData?.bookingDateTime != " " && trackData?.bookingDateTime != nil) {
                cell.statusTime.text = dateFormatted2(date: trackData?.bookingDateTime ?? "")
            } else {
                cell.statusTime.text = ""
            }
        } else if sectionType.statusName == "Order Confirmed" {
            
//            if type == .accepted{
//                if indexPath.row < type.value && (trackData?.status == type.backendStatus) {
//                    cell.lineView.backgroundColor = #colorLiteral(red: 0.767647922, green: 0.05847137421, blue: 0.2396849394, alpha: 1)
//                    cell.circleView.backgroundColor = #colorLiteral(red: 0.767647922, green: 0.05847137421, blue: 0.2396849394, alpha: 1)
//                    cell.blurView.alpha = 0
//                }
//            }
            
            if (trackData?.acceptDateTime != "" && trackData?.acceptDateTime != " " && trackData?.acceptDateTime != nil) {
                cell.statusTime.text = dateFormatted2(date: trackData?.acceptDateTime ?? "")
            } else {
                cell.statusTime.text = ""
            }
        } else if sectionType.statusName == "Ready for Pickup" {
            
//            if type == .inprogress{
//                if indexPath.row < type.value && trackData?.status == type.backendStatus {
//                    cell.lineView.backgroundColor = #colorLiteral(red: 0.767647922, green: 0.05847137421, blue: 0.2396849394, alpha: 1)
//                    cell.circleView.backgroundColor = #colorLiteral(red: 0.767647922, green: 0.05847137421, blue: 0.2396849394, alpha: 1)
//                    cell.blurView.alpha = 0
//                    trackOrder.isHidden = true //false
//                    tableViewheight.constant = 50
//                }
//            }
            
            if (trackData?.readyForPickUpDateTime != "" && trackData?.readyForPickUpDateTime != " " && trackData?.readyForPickUpDateTime != nil) {
                cell.statusTime.text = dateFormatted2(date: trackData?.readyForPickUpDateTime ?? "")
            } else {
                cell.statusTime.text = ""
            }
        } else if sectionType.statusName == "Order Picked Up" {
            
//            if type == .completed{
//                if indexPath.row < type.value && trackData?.status == type.backendStatus {
//                    cell.lineView.backgroundColor = #colorLiteral(red: 0.767647922, green: 0.05847137421, blue: 0.2396849394, alpha: 1)
//                    cell.circleView.backgroundColor = #colorLiteral(red: 0.767647922, green: 0.05847137421, blue: 0.2396849394, alpha: 1)
//                    cell.blurView.alpha = 0
//                }
//            }
            if (trackData?.completedDatetimeUtc != "" && trackData?.completedDatetimeUtc != " " && trackData?.completedDatetimeUtc != nil) {
                cell.statusTime.text = dateFormatted2(date: trackData?.completedDatetimeUtc ?? "")
            } else {
                cell.statusTime.text = ""
            }
        }
        
        
      
      switch type {
      case .unAssigned:
//        print(indexPath.row)
//        print(trackData?.status)
//        print(type.backendStatus)
       if indexPath.row < type.value && (trackData?.status == type.backendStatus) {
            cell.lineView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            cell.circleView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            cell.blurView.alpha = 0
       }
       
       if indexPath.row < 3 && (trackData?.status == Driver.driverFailed.rawValue) {   // 16 for driver unAssigned
            cell.lineView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            cell.circleView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            cell.blurView.alpha = 0
       }
        
      case .accepted:
        if indexPath.row < type.value && (trackData?.status == type.backendStatus) {
            cell.lineView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            cell.circleView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            cell.blurView.alpha = 0
        }
      case .inprogress:
         if indexPath.row < 4 && trackData?.status == type.backendStatus {
            cell.lineView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            cell.circleView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            cell.blurView.alpha = 0
            trackOrder.isHidden = true //false
            tableViewheight.constant = 50
        }
      case .completed:
         if indexPath.row < type.value && trackData?.status == type.backendStatus {
            cell.lineView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            cell.circleView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            cell.blurView.alpha = 0
        }
      default:
        cell.lineView.backgroundColor = lineColor
        cell.circleView.backgroundColor = lineColor
        cell.blurView.alpha = 0.5
      }
      
      if indexPath.row == 3 && trackData?.status == Driver.driverFailed.rawValue {
        cell.lineView.backgroundColor = lineColor
        cell.circleView.backgroundColor = headerColor
      }
      
      if indexPath.row == type.value && trackData?.status == type.backendStatus {
        cell.lineView.backgroundColor = lineColor
        cell.circleView.backgroundColor = headerColor
      }
      
      if sectionType == .orderReady {
        cell.lineView.isHidden = true
      } else {
        cell.lineView.isHidden = false
      }
      cell.backgroundColor = .white
      return cell
    }
  }

  //Mark: Track Order Count Down
  extension TrackOrderViewController {
    
    @objc func setTimeLeft() {
      let endTime = Date()
        guard let bookingTime = trackData?.bookingDateTime else {
        return
      }
      guard let min = trackData?.time else {
        return
      }
      let startTime = dateTime(date: bookingTime)
        let timeInterval = endTime.timeIntervalSince(startTime)
        let time = TimeInterval(Int(min*60)) - timeInterval
        if min > (Int(timeInterval)/60) {
          self.time.text = timeString(time: time)
        } else {
        countDownTimer?.invalidate()
        countDownTimer = nil
        //customAlert(controller: self, message: "Your order will be delivered shortly. Sorry, for the delay.".localizedString)
        self.time.text = "0:0"
        }
    }
    
    //MARK: Convert Time Interval into Second and Mins
    func timeString(time: TimeInterval) -> String {
      let minutes = Int(time) / 60 % 60
      let seconds = Int(time) % 60
      return String(format: "%02i:%02i", minutes, seconds)
    }
  }
