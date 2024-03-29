//
// Copyright (c) 2017 by ACI Worldwide, Inc.
// All rights reserved.
//
// This software is the confidential and proprietary information
// of ACI Worldwide Inc ("Confidential Information"). You shall
// not disclose such Confidential Information and shall use it
// only in accordance with the terms of the license agreement
// you entered with ACI Worldwide Inc.
//

#import <Foundation/Foundation.h>

/// An enumeration for the various types of error that resulted in an operation's failure.
typedef NS_ENUM(NSInteger, OPPErrorCode) {
    /// Unsupported transaction payment params.
    OPPErrorCodePaymentParamsUnsupported = 1000,
    /// Transaction checkoud ID is not valid.
    OPPErrorCodePaymentParamsCheckoutIDInvalid = 1010,
    /// Brand doesn't match payment params class.
    OPPErrorCodePaymentParamsBrandInvalid = 1011,
    /// The token identifier is invalid. Must be alpha-numeric string of length 32.
    OPPErrorCodePaymentParamsTokenIDInvalid = 1090,
    /// Tokenization is not supported for chosen payment brand.
    OPPErrorCodePaymentParamsTokenizationUnsupported = 1091,

    /// Holder must at least contain first and last name.
    OPPErrorCodeCardHolderInvalid = 1110,
    /// Invalid card number. Does not pass the Luhn check.
    OPPErrorCodeCardNumberInvalid = 1111,
    /// Unsupported card brand.
    OPPErrorCodeCardBrandInvalid = 1112,
    /// Month must be in the format MM.
    OPPErrorCodeCardMonthInvalidFormat = 1113,
    /// Year must be in the format YYYY.
    OPPErrorCodeCardYearInvalidFormat = 1114,
    /// Card is expired.
    OPPErrorCodeCardExpired = 1115,
    /// CVV invalid. Must be three or four digits.
    OPPErrorCodeCardCVVInvalid = 1116,
    
    /// Holder of the bank account is not valid.
    OPPErrorCodeBankAccountHolderInvalid = 1130,
    /// IBAN is not valid.
    OPPErrorCodeBankAccountIBANInvalid = 1131,
    /// The country code of the bank is invalid. Should match ISO 3166-1 two-letter standard.
    OPPErrorCodeBankAccountCountryInvalid = 1132,
    /// The name of the bank which holds the account is invalid.
    OPPErrorCodeBankAccountBankNameInvalid = 1133,
    /// The BIC (Bank Identifier Code (SWIFT)) number of the bank account is invalid.
    OPPErrorCodeBankAccountBICInvalid = 1134,
    /// The code associated with the bank account is invalid.
    OPPErrorCodeBankAccountBankCodeInvalid = 1135,
    /// The account number of the bank account is invalid.
    OPPErrorCodeBankAccountNumberInvalid = 1136,
    
    /// The Apple Pay payment token data is invalid. To perform this type of transaction a valid payment token data is needed.
    OPPErrorCodeApplePayTokenDataInvalid = 1150,
    
    /// Checkout info cannot be loaded.
    OPPErrorCodeCheckoutInfoCannotBeLoaded = 2000,
    /// There are no available payment methods in checkout.
    OPPErrorCodeNoAvailablePaymentMethods = 2001,
    /// Payment method is not available.
    OPPErrorCodePaymentMethodNotAvailable = 2002,
    
    /// The transaction was declined. Please contact the system administrator of the merchant server to get the reason of failure.
    OPPErrorCodeTransactionProcessingFailure = 2010,
    /// The сheckout configuration is not valid.
    OPPErrorCodeInvalidCheckoutConfiguration = 2020,
    
    /// Unexpected connection error. Please contact the system administrator of the server.
    OPPErrorCodeConnectionFailure = 3000,
    
    /// File loaded from resources does not have valid checksum. Make sure you installed the framework correctly and no one has been tampering with the application.
    OPPErrorCodeSecurityXMLManipulation = 4000,
    
    /// Invalid framework version. Versions of base and extension frameworks are not matching.
    OPPErrorCodeFrameworkVersionInvalid = 5000
};

/**
 Contains all error messages and codes that returned by SDK methods.
 
 To retrieve the return code ([OPPErrorCode](../Constants/OPPErrorCode.html )) use the code attribute of the NSError object:
 
     [error code];
 
 To retrieve the error description look to localized description:
 
     (NSString *)error.localizedDescription;
 
 ## User info dictionary keys
 
 This key may exist in the user info dictionary, in addition to those defined for NSError.
 
 - `NSString * const OPPErrorTransactionFailureDetailsKey`
 
 ### Constants
 
 `OPPErrorTransactionFailureDetailsKey`
 The corresponding value is an `NSDictionary` containing the detail transaction failure information.
 
 ##Error codes
 Below you can find all currently supported error codes. See also separate page with OPPErrorCode enum definition.
 ###Payment params errors:
 - 1000: Unsupported transaction payment params.
 - 1010: Transaction checkoud ID is not valid.
 - 1011: Brand doesn't match payment params class.
 - 1090: The token identifier is invalid. Must be alpha-numeric string of length 32.
 - 1091: Tokenization is not supported for chosen payment brand.

 ###Card errors:
 - 1110: Holder must at least contain first and last name.
 - 1111: Invalid card number. Does not pass the Luhn check.
 - 1112: Unsupported card brand.
 - 1113: Month must be in the format MM.
 - 1114: Year must be in the format YYYY.
 - 1115: Card is expired.
 - 1116: CVV invalid. Must be three or four digits.

 ###Bank account errors:
 - 1130: Holder of the bank account is not valid.
 - 1131: IBAN is not valid.
 - 1132: The country code of the bank is invalid. Should match ISO 3166-1 two-letter standard.
 - 1133: The name of the bank which holds the account is invalid.
 - 1134: The BIC (Bank Identifier Code (SWIFT)) number of the bank account is invalid.
 - 1135: The code associated with the bank account is invalid.
 - 1136: The account number of the bank account is invalid.
 
 ###Apple Pay errors:
 - 1150: The Apple Pay payment token data is invalid. To perform this type of transaction a valid payment token data is needed.
 
 ###Transaction errors:
 - 2000: Checkout info cannot be loaded.
 - 2001: There are no available payment methods in checkout.
 - 2002: Payment method is not available.
 - 2010: The transaction was declined. Please contact the system administrator of the merchant server to get the reason of failure.
 - 2020: The сheckout configuration is not valid.
 
 ###Connection errors:
 - 3000: Unexpected connection error. Please contact the system administrator of the server.
 
 ###Security errors:
 - 4000: File loaded from resources does not have valid checksum. Make sure you installed the framework correctly and no one has been tampering with the application.
 
 ###Linking errors:
 - 5000: Invalid framework version. Versions of base and extension frameworks are not matching.
 */

@interface OPPErrors : NSObject

FOUNDATION_EXPORT NSString *const OPPErrorDomain;

FOUNDATION_EXPORT NSString *const OPPErrorTransactionFailureDetailsKey;

@end
