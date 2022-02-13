//
//  TutorialPageContentController.swift
//  CLApp
//
//  Created by click Labs on 7/17/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

class TutorialPageContentController: UIViewController {
    
    // MARK: - Variables
    fileprivate var data: TutorialData?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailLabel.text = data?.title
        
    }
    
}
