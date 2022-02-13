//
//  ImagePickerButton.swift
//  CLApp
//
//  Created by Akhilesh Gandotra on 17/01/17.
//  Copyright © 2017 Akhilesh Gandotra. All rights reserved.
//
// ************************ Version 1.0 ***********************//
//

import UIKit

// MARK: Picker Enumrations
enum PickerResult {
    case success(String) // Return local path of image
    case error(ImagePickerError)
}

enum PickerType {
    case camera
    case photoLibrary
    case both
}

enum ImagePickerError: LocalizedError {
    case cameraNotFound
    case photoLibrary
    case pickerCancelled
    case imageNotPicked
    
    var errorDescription: String? {
        switch self {
        case .cameraNotFound:
            return "Camera not found in this device.".localizedString
        case .photoLibrary:
            return "Photo library found in this device.".localized
        case .pickerCancelled:
            return "Image picker cancelled".localizedString
        case .imageNotPicked:
            return "Could not pick image in the info".localizedString
        }
    }
}

// MARK: Class Image_Picker_Button
class ImagePickerButton: UIButton {
    
    // MARK: Variables
    var imageCallBack: ((_ result: PickerResult) -> Void)?
    private var pickerType: PickerType? = .both
    fileprivate var filePath: String?
    private var fileName = "#fileName"
    private var picker: UIImagePickerController?
    private var cameraTitle = "Take a new photo".localizedString
    private var photoLibraryTitle = "Open Photo Library".localizedString
    let highResolutionSize = 2048 // can change according to your app.
    
    
    // MARK: Starting
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(ImagePickerButton.pressAction(_:)), for: UIControl.Event.touchUpInside)
    }
    
    deinit {
    }
    
    // MARK: Customizables results for selecting file name, picker type and titles
    @discardableResult
    func customize(type: PickerType, fileName: String = "#fileName") -> ImagePickerButton {
        pickerType = type
        self.fileName = fileName.trimmedString() == "" ? "#fileName" : fileName
        return self
    }
    @discardableResult
    func giveCameraTitle(string: String) -> ImagePickerButton {
        self.cameraTitle = string
        return self
    }
    @discardableResult
    func givePhotoLibraryTitle(string: String) -> ImagePickerButton {
        self.photoLibraryTitle = string
        return self
    }
    
    
    // MARK: Button Action
    @objc private func pressAction(_ sender: ImagePickerButton) {
        
        guard let pickerType = self.pickerType else {
            return
        }
        self.selectImage(fileName: fileName, pickerType: pickerType)
    }
    
    // MARK: Document Directory Path
    func pathToDocumentsDirectory() -> String {
        
        let documentsPath: AnyObject = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as AnyObject
        if let path = documentsPath as? String {
            return path
        }
        fatalError("could not return path")
    }
    
    // MARK: Remove image from directory (can be called when image uploaded to backend) optional
    func removeImage() {
        let fileManager = FileManager.default
        let path = pathToDocumentsDirectory()
        if self.filePath != nil {
            let filePath = "\(path)/\(fileName)"
            do {
                try fileManager.removeItem(atPath: filePath)
            } catch let error as NSError {
                print(error.debugDescription)
            }
            self.filePath = nil
        }
    }
    
    
    // MARK: Functions for selecting image from picker
    private func selectImage( fileName: String, pickerType: PickerType) {
        filePath = pathToDocumentsDirectory().appending("/\(fileName)")
        self.openImagePicker(pickertype: pickerType)
    }
    
    
    private func openImagePicker(pickertype: PickerType) {
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        
        switch pickertype {
        case .camera:
            self.openCamera(actionSheet: actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel".localizedString, style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
            })
            actionSheet.addAction(cancelAction)
            rootViewController.present(actionSheet, animated: true, completion: nil)
        case .photoLibrary:
            self.openPhotoLibrary(actionSheet: actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel".localizedString, style: .cancel, handler: {  (alert: UIAlertAction!) -> Void in
            })
            actionSheet.addAction(cancelAction)
            rootViewController.present(actionSheet, animated: true, completion: nil)
            
        default:
            openCamera(actionSheet: actionSheet)
            openPhotoLibrary(actionSheet: actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel".localizedString, style: .cancel, handler: {  (alert: UIAlertAction!) -> Void in
            })
            actionSheet.addAction(cancelAction)
            rootViewController.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    private func openCamera(actionSheet: UIAlertController) {
        picker = UIImagePickerController()
        self.picker?.delegate = self
        
        let cameraAction = UIAlertAction(title: cameraTitle.localized, style: .default, handler: {  (alert: UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                
                self.picker?.sourceType = UIImagePickerController.SourceType.camera
                guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController,
                    let picker = self.picker else {
                        return
                }
                rootViewController.present(picker, animated: true, completion: nil)
            } else {
                if let imageCallBack =  self.imageCallBack {
                    imageCallBack(.error(.cameraNotFound))
                }
            }
        })
        actionSheet.addAction(cameraAction)
    }
    
    private  func openPhotoLibrary(actionSheet: UIAlertController) {
        picker = UIImagePickerController()
        self.picker?.delegate = self
        
        let photoLibraryAction = UIAlertAction(title: photoLibraryTitle.localized, style: .default, handler: { (alert: UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                self.picker?.sourceType = UIImagePickerController.SourceType.photoLibrary
                guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController,
                    let picker = self.picker else {
                        return
                }
                rootViewController.present(picker, animated: true, completion: nil)
            } else {
                if let imageCallBack =  self.imageCallBack {
                    imageCallBack(.error(.photoLibrary))
                }
            }
        })
        actionSheet.addAction(photoLibraryAction)
    }
}

extension ImagePickerButton: UIImagePickerControllerDelegate { }

extension ImagePickerButton: UINavigationControllerDelegate {
    // MARK: Image Picker Delgates
    @nonobjc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
            
            guard let image = pickedImage.jpegData(compressionQuality: 1.0) else {
                return
            }
            
            if image.count > highResolutionSize { //high resolution check
                if let data = pickedImage.jpegData(compressionQuality: 0.2) {
                    do {
                        try data.write(to: URL(fileURLWithPath: filePath ?? "no Path"), options: .atomic)
                    } catch {
                        print(error)
                    }
                }
            } else {
                if let data = pickedImage.jpegData(compressionQuality: 0.4) {
                    do {
                        try data.write(to: URL(fileURLWithPath: filePath ?? "no Path"), options: .atomic)
                    } catch {
                        print(error)
                    }
                }
            }
            guard let imageCallBack =  self.imageCallBack,
                let filepath = filePath else {
                    return
            }
            imageCallBack(.success(filepath))
        } else {
            if let imageCallBack =  self.imageCallBack {
                imageCallBack(.error(.imageNotPicked))
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if let imageCallBack =  self.imageCallBack {
            imageCallBack(.error(.pickerCancelled))
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension String {
  
  var localizedString: String {
    let bundle = Bundle.main
    if let path = bundle.path(forResource: Localize.currentLanguage(), ofType: "lproj"), let bundal = Bundle(path: path) {
      return bundal.localizedString(forKey: self, value: "", table: "Localizable")
    }
    fatalError("Key Not Found")
  }
  
//    var localizedString: String {
//      return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
//    }
    public func trimmedString() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
