//
//  TutorialDetails.swift
//  FoodFox
//
//  Created by socomo on 17/10/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import Foundation
import UIKit

struct TutorialDataDetails {
    var tutorailId: Int?
    var isBlock: Bool?
    var tutorialImaageUrl: String?
    var description: String?
    
    init(param: [String: Any]) {
   
        if let id  = param["tutorialId"] as? Int {
            self.tutorailId = id
        }
        if let isBlock = param["isBlock"] as? Bool {
            self.isBlock = isBlock
        }

        if let tutorailImage = param["tutorialsImageURL"] as? [String: Any] {
            if let originalImage = tutorailImage["original"] as? String {
               self.tutorialImaageUrl = originalImage
            }
        }
        
        if let description = param["description"] as? String {
            self.description = description
        }
    }
}

class TutorialDetails {
//    static var sharedInstance = TutorialDataDetails()
    var tutorialsCount: Int?
    var tutorialData = [TutorialDataDetails]()

    
    init(data: [String: Any]) {
        if let tutorialData = data["tutorialData"] as? [AnyObject] {
            var tutorilaItems = [TutorialDataDetails]()
            if let tutorialArray = tutorialData as? [[String: AnyObject]] {
                for dict in tutorialArray {
                    let tutObj: TutorialDataDetails = TutorialDataDetails(param: dict)
                    tutorilaItems.append(tutObj)
                }
                self.tutorialData = tutorilaItems
            }
            
        }
//        if let tutorialData = data["tutorialData"] as? [[String: Any]]{
//            self.tutorialData = tutorialData.map({ TutorialDataDetails(param: $0)})
//        }
        
        if let tutorialCount = data["count"] as? Int {
            self.tutorialsCount = tutorialCount
        }
    }
}


class Banner {
    var imageUrl: String?
    init(data: [String: Any]) {
        if let image = data["imageURL"] as? [String: Any] {
            if let original = image["original"] as? String {
                self.imageUrl = original
            }
        }
    }
}
