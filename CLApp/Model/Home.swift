//
//  Home.swift
//  FoodFox
//
//  Created by socomo on 16/10/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import Foundation
import UIKit


struct SponseredDetails {
    var sponseredId: String?
    var mealrating: Double?
    var mealId: String?
    var mealImageUrl: String?
    var restaurentId: String?
    var branchId: String?
  
    init(param: [String: Any]) {
    
        if let id = param["_id"] as? String {
            self.sponseredId = id
        }
      if let restaurentId = param["restaurantId"] as? String {
        self.restaurentId = restaurentId
      }
      if let branchId = param["branchId"] as? String {
        self.branchId = branchId
      }
        if let rating = param["rating"] as? Double {
            self.mealrating = rating
        }
        if let mealid = param["mealId"] as? String {
            self.mealId = mealid
        }
        if let imageurl = param["imageURL"] as? [String: Any] {
            if let image = imageurl["original"] as? String {
                self.mealImageUrl = image
            }
        }
    }
    
}

struct DiscoverData {
    var discoverId: String?
    var categoryId: String?
    var categoryname: String?
    var categoryIdImageUrl: String?
    var cuisineRank: Int?
    
    init(param: [String: Any]) {
        
        if let id = param["_id"] as? String {
            self.discoverId = id
        }
        if let categoryId = param["categoryId"] as? String {
            self.categoryId = categoryId
        }
        if let categoryName = param["categoryName"] as? String {
            self.categoryname = categoryName
        }
        if let categoryImage = param["categoryIdImageURL"] as? String {
            self.categoryIdImageUrl = categoryImage
        }
        if let cuisinerank = param["cuisine_rank"] as? Int {
            self.cuisineRank = cuisinerank
        }
    }
}

struct RestaurantNear {
    var restaurantId: String?
    var restaurantName: String?
    var email: String?
    var phoneNo: String?
    var estimateDeliveryTime: Double?
    var rating: Double?
    var speciality: String?
    var ranking: Int?
    var deliveryCharge: Double?
    var minimumOrderValue: Int?
    var estimatedPreparationTime: Double?
    var isPickUpService: Bool?
    var address: String?
    var restaurantDescription: String?
    var logoImageUrl: String?
    var restaurantImageURL: String?
    var distanceCalculated: Double?
    var longitude: Double?
    var latitude: Double?
    var isOpenRestaurent: Int?
    var paymentMethods: [String] = []
    var addNotMessage: [String] = []
    var addNotes: Int?
    init(param: [String: Any]) {
        self.restaurantPersonalInfo(data: param)
      
        if let isOpenRestaurent = param["openingStatus"] as? Int {
            self.isOpenRestaurent = isOpenRestaurent
        }
        if let isOpenRestaurent = param["openingStatus"] as? String {
            self.isOpenRestaurent = Int(isOpenRestaurent)
        }
        if let deliveryTime = param["estimateDeliveryTime"] as? Double {
            self.estimateDeliveryTime = deliveryTime
        }
        if let deliveryTime = param["estimatePreparationTime"] as? Double {
            self.estimatedPreparationTime = deliveryTime
        }
        if let deliveryCharges = param["deliveryCharge"] as? Double {
            self.deliveryCharge = deliveryCharges
        }
        if let orderValue = param["minimumOrderValue"] as? Int {
            self.minimumOrderValue = orderValue
        }
        if let isPickUp = param["IsPickUpService"] as? Bool {
            self.isPickUpService = isPickUp
        }
        if let restaurantAddress = param["address"] as? String {
            self.address = restaurantAddress
        }
        if let description = param["description"] as? String {
            self.restaurantDescription = description
        }
        if let restaurantLogoImage = param["logoURL"] as? [String: Any], let originalImage = restaurantLogoImage["original"] as? String {
            self.logoImageUrl = originalImage
        }
        if let restaurantImage = param["imageURL"] as? [String: Any], let originalImage = restaurantImage["original"] as? String {
            self.restaurantImageURL = originalImage
        }
        if let distance = param["distanceCalculated"] as? Double {
            self.distanceCalculated = distance
        }
        if let locationLongitude = param["locationLong"] as? Double {
            self.longitude = locationLongitude
        }
        if let locationLatitude = param["locationLat"] as? Double {
            self.latitude = locationLatitude
        }
        if let paymentTypes = param["paymentMethods"] as? [String] {
            self.paymentMethods = paymentTypes
        }
        if let  addNotMessage  = param["addNotMessage"] as? [String] {
            self.addNotMessage  =  addNotMessage
        }
        if let  addNotes  = param["addNotes"] as? Int {
            self.addNotes  =  addNotes
        }
        
        
        if let locationLatLongs = param["locationLongLat"] as? [String: Any], let coordinates = locationLatLongs["coordinates"] as? [String] {
            self.latitude = Double(coordinates[1])
            self.longitude = Double(coordinates[0])
        }
    }
   
    mutating func restaurantPersonalInfo(data: [String: Any]) {
        if let id = data["_id"] as? String {
            self.restaurantId = id
        }
        if let restaurantName = data["restaurantName"] as? String {
            self.restaurantName = restaurantName
        }
        if let restaurantEmail = data["email"] as? String {
            self.email = restaurantEmail
        }
        if let restaurantContact = data["phoneNo"] as? String {
            self.phoneNo = restaurantContact
        }
        if let rating = data["rating"] as? Double {
            self.rating = rating
        }
        if let speciality = data["speciality"] as? String {
            self.speciality = speciality
        }
        if let ranking = data["ranking"] as? Int {
            self.ranking = ranking
        }
    }
}

class Home {
    
    var sponsoredData = [SponseredDetails]()
    var discoverData = [DiscoverData]()
    var restaurantNearToYouCount: Int = 0
    var restaurantNearToYou = [RestaurantNear]()
    var newRestaurant = [RestaurantNear]()
    
    init(data: [String: Any]) {
        if let sponser = data["sponsoredData"] as? [[String: Any]] {
            self.sponsoredData = sponser.map({ SponseredDetails(param: $0)})
        }
        if let discover = data["discoverData"] as? [[String: Any]] {
            self.discoverData = discover.map({ DiscoverData(param: $0)})
            self.discoverData.sort { (d1: DiscoverData, d2: DiscoverData) -> Bool in
                return d1.cuisineRank ?? 0 < d2.cuisineRank ?? 0
            }
        }
        if let restaurantCount = data["restaurantNearToYouCount"] as? Int {
            self.restaurantNearToYouCount = restaurantCount
        }
        if let restaurantNear = data["restaurantNearToYou"] as? [[String: Any]] {
            self.restaurantNearToYou = restaurantNear.map({ RestaurantNear(param: $0)})
            print(self.restaurantNearToYou)
            let openRestaurants = self.restaurantNearToYou.filter({
                 $0.isOpenRestaurent == 1
            })
            print(openRestaurants)
            let busyRestaurants = self.restaurantNearToYou.filter({
                $0.isOpenRestaurent == 2
            })
            print(busyRestaurants)
            let closedRestaurants = self.restaurantNearToYou.filter({
                $0.isOpenRestaurent == 3
            })
            print(closedRestaurants)
            let combinedArray = [openRestaurants, closedRestaurants, busyRestaurants]
            self.restaurantNearToYou = combinedArray.flatMap { $0 }
            print(self.restaurantNearToYou)
        }
        if let newRestaurant = data["exploreNewRestaurants"] as? [[String: Any]] {
            self.newRestaurant = newRestaurant.map({RestaurantNear(param: $0)})
        }
        
    }
}
