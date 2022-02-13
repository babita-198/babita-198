//
//  CLAppIdentifier.swift
//  FoodFox
//
//  Created by clicklabs on 30/11/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import Foundation

// MARK: All Identifier
struct Identifier {
   static let addressListCell = "AddressListCell"
   static let addressTextCell = "AddressTextCell"
   static let addressTitleButtonCell = "AddressTitleButtonCell"
   static let addressListViewController = "AddressListViewController"
   static let saveAddressViewController = "SaveAddressViewController"
   static let addresFlowStoryBoard = "AddressFlow"
   static let selectionCell = "SectionCell"
   static let sponserTableCell = "SponserTableCell"
   static let cuisineTableCell = "CuisineTableCell"
   static let restaurentTableCell = "RestaurentTableCell"
   static let restaurentCollectionViewCell = "RestaurentCollectionViewCell"
   static let newRestaurentTableCell = "NewRestaurentTableCell"
   static let gridCollectionView = "GridCollectionView"
   static let cuisineCollectionCell = "CuisineCollectionCell"
   static let mapCollectionViewCell = "MapCollectionViewCell"
   static let settingTableViewCell = "SettingTableViewCell"
   static let settingViewController = "SettingViewController"
   static let addCardViewController = "AddCardViewController"
   static let paymentStoryBoard = "PaymentStoryBoard"
   static let discountCell = "DiscountCell"
   static let cardTableViewCell = "CardTableViewCell"
   static let amountTableViewCell = "AmountTableViewCell"
   static let cartItemTableViewCell = "CartItemTableViewCell"
   static let itemsAddedInCartTable = "ItemsAddedInCartTable"
   static let priceDetailsTableView = "PriceDetailsTableView"
   static let paymentOptionViewController = "PaymentOptionViewController"
   static let orderDoneViewController = "OrderDoneViewController"
   static let myAddressController = "MyAddressController"
   static let orderListCell = "OrderListCellTableViewCell"
   static let orderStoryBoard = "OrderStoryboard"
   static let myOrderController = "MyOrderController"
   static let orderRatingCellTableViewCell = "OrderRatingCellTableViewCell"
   static let pastOrderCell = "PastOrderCell"
   static let orderDetailViewController = "OrderDetailViewController"
   static let orderCancelPopUpViewController = "OrderCancelPopUpViewController"
   static let orderCancelReasonPopUp = "OrderCancelReasonPopUp"
   static let itemTableViewCell = "ItemTableViewCell"
   static let orderAddressCell = "OrderAddressCell"
   static let trackTableViewCell = "TrackTableViewCell"
   static let trackOrderViewController = "TrackOrderViewController"
   static let trackOrderMapViewController = "TrackOrderMapViewController"
   static let referController = "ReferController"
   static let popUpCancellationCell = "PopUpCancellationCell"
   static let ratingPopUpViewController = "RatingPopUpViewController"
   static let shareAppCellCollectionViewCell = "ShareAppCellCollectionViewCell"
   static let shareAppPopUpController = "ShareAppPopUpController"
   static let addOnCell = "AddOnCell"
   static let pushView = "PushNotificationView"
   static let infoCell = "InfoCell"
   static let searchOnMapViewController = "SearchOnMapViewController"
   static let customMarkerView = "CustomMarkerView"
   static let selectLanguage = "SelectLanguageController"
  static let promoCodeCell = "PromoCodeCell"
  static let walletController = "MyWalletViewController"
  static let contactSupport = "ContactSupportViewController"
  static let chatCell = "ChatSupportCell"
  static let contact = "ContactSupportController"
  static let reviewCell = "ReviewCell"
  static let reviewController = "ReviewViewController"
  static let messageAlert = "MessageAlertView"
  static let viewTiming = "ViewTimingController"
  static let menuCell = "MenuTableViewCell"
  static let restaurantItemCell = "RestaurantItemCollectionViewCell"
  static let gridMenu = "GridMenuCollectioncell"
    static let listMenu = "ListMenuCollectioncell"
}

// MARK: All API
struct API {
  static let customerUpdateLocation = "api/customer/UpdateCustomerLocation"
  static let addNewAddress = "api/customer/addNewAddress"
  static let getAllAddress = "api/customer/getAllAddress"
  static let updateAddress = "api/customer/updateAddress"
  static let deleteAddress = "api/customer/removeAddress"
  static let addToCart = "api/customer/addToCart"
  static let createTask = "api/booking/CreateBooking"
  static let getAllOrder = "api/customer/getAllOrders"
  static let getOrderDetail = "api/customer/getOrderDetails"
  static let orderCancel = "api/customer/cancelledOrder"
  static let trackOrder = "api/customer/trackOrderStatus"
  static let trackOrderMap = "api/customer/getDriverLocation"
  static let getReason = "api/customer/getCancellationReason"
  static let giveRating = "api/customer/giveRating"
  static let getReferralCode = "api/customer/getCreditsAndReferralCodes"
  static let paymentList = "api/customer/getPaymentMethods"
  static let getPromo = "api/customer/getPromoCode"
  static let applyPromo = "api/customer/applyPromoCode"
  static let contact = "api/web/contactUs"
  static let subjectList = "api/admin/getSubject"
  static let getAllReview = "api/customer/getAllReviewsOfRestaurant"
  static let availability = "api/customer/getbranchDetails"
  static let getSettingData = "api/customer/getSettingAndWalletAmount"
   static let updateNotification = "api/customer/updateSetting"
}

struct Message {
  static let cartRemove = "You had added items of different restaurant in cart. Are you sure you want to clear Cart ?".localizedString
  static let viewCart = "You have added different variations of this item. Please view cart to remove specific item.".localizedString
}
