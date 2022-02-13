![alt text](CL_iCon.png)

# Welcome to the iOS-Base-Project!
Compatible with Xcode 12 and Swift 5

Our goal of this project is to how we can write the best code with following iOS and Swift design patterns. The main focus is on clarity, readability, reusability, brevity and bug-free code. They also help you change and replace components in your code without too much of a hassle.

:point_right: **suggestions and contributions are welcome!** :call_me:

# Steps To Use Base Project

Step1: How to rename project
  - Download Base Project
  - Remove Pod, Podfile.lock and workspace file of project.
    Note:  You can save Podfile on other location for later use.
  -   go to terminal - set project path -Pod install
  
 Step 2: fix Bridge Header bug
     - go to project -> Target -> build setting->Swift Compiler-General
     
     - objective bridge header put CLApp-Bridge header file path according to your pc 
     for Example : /Users/rajneshwarsingh/Desktop/new FoodFox/foodfox_ios/CLApp/CLApp-Bridging-Header.h

     - run project

Note : if any case  new developer  facing issues regarding pod not properly install

     - Remove Pod,podfile, Podfile.lock and workspace file of project.
     - pod init 
     - Add all needed pods framework in podfile.
     - pod install


Note: Every time add config file run pod install cmd again.

CLApp Base Project Modules
==========================

App Multi Environment Settings
-----------------------------

"AppSettings" Module will allow user to switch envirnment any time without changing all keys.
User has to change only  app scheme. User can place those keys like "Base url" that will be different for all envirnment such as test, dev, client or app store.


HTTPRequest
-----------


This module will use for Api calls. HTTPRequest will in corprate with Alamofire. 
User need to call method 

HTTPRequest(method: HTTPMethod, path: String, parameters: Parameters?, encoding: EncodingType, files: [HSFile]?) for Api call

-  @HTTPMethod: Request type such as GET,PUT,POST etc..
-  @path : name of Api i.e email_login, get_profile etc..
-  @Parameters: Dictionary of parameters that will be pass to server for api call. If api  dont need to send parameters then pass black dictionary i.e [] for parameters
-  @EncodingType: its encoding type of api request i.e .URL or .JSON
-  @[HSFile]: Array of file uploaded to server i.e image. If there is not any file to be uploaded on server then pass this parameter nil.


HTTPRequest will return two types of Completion block after Api execution 

handler(httpModel: false, delay: 0) 

- @httpModel : If value for httpModel is true it will return server response object in form of HttpModel. HttpModel contains three object status code, data and error. You can get values with . operator.
   If value for httpModel is false then it will simply return completion with dictionary object and error.
- @delay: Api will call after given delay.

multipartHandler(httpModel: true, delay: 0, completion: <#T##HTTPRequestHandler##HTTPRequestHandler##(Any?, Error?) -> Void#>)
 
if you are calling api with multi parts then implement multipart completion.


Login Manager (Facade Design pattern)
--------------

This module will handle all user related Api calls. Login Manager's main task are:

- User related Api calls i.e login, signup, profile etc
- Manage user related data in Modals
- After api call login manager will save data in Keychain 
- If user logout it will remove user related info from keychain.
- Login manager save user data by creating object of Me() call.



TextField Validation 
---------------------

This module will validate textfield input as per given behaiviour. It will validate all textfield and return with key - value object.

- User need to intialize object of CLValidatorManager().
- User need to set some properties for textfield. 

   BehaviorType
        -   Set type of textfield like email, passworr, phone number, user name etc.
   Idientifer
        -  set identifier  for textfield which is to be passed in api call
   validationRuleSet
        -   Set rule for textfield validation such as if textfield is type of email then "emailRulesSet" will apply
- Register textfield with ValidationManager.

-  validatorManager.startValidation
        Start validation method will start validate and return error message if textfield is not valide or key - value object.


Use full Links
==============

*******************************
Multi envirnment configuration

App Multi Environment Settings (Dev,Testing,Client, Release)
[Tutorial-1](http://www.tothenew.com/blog/working-with-multiple-build-environments-in-ios/)
[Tutorial-2](http://www.teratotech.com/blog/xcode-7-steps-to-easily-switch-between-multiple-environments/)

***************
[Keychain Access](https://github.com/kishikawakatsumi/KeychainAccess/tree/master)

*********
[Alamofire](https://github.com/Alamofire/Alamofire)

************
[AFDateHelper](https://github.com/melvitax/DateHelper)

*************
[MBProgressHUD](https://github.com/jdg/MBProgressHUD)

*********
[Validator](https://github.com/adamwaite/Validator)

*********
[SwiftLint](https://github.com/realm/SwiftLint)

*********
[R.swift](https://github.com/SwiftGen/SwiftGen)

    
        

  
  

































