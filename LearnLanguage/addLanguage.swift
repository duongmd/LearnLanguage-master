//
//  addLanguage.swift
//  Learning-Language
//
//  Created by PIRATE on 11/11/16.
//  Copyright © 2016 Duong. All rights reserved.
//

import UIKit
import MobileCoreServices

class addLanguage: UIViewController  {
    
    
    var imagePicker: UIImagePickerController?
    let database = DataBase.sharedInstance

    @IBOutlet weak var nameLanguage: UITextField!
    @IBOutlet weak var imageLanguage: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tapImage()
    }
    
    func tapImage(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(getImage(_:)))
        imageLanguage.isUserInteractionEnabled = true
        imageLanguage.addGestureRecognizer(tap)
    }
    
    func getImage(_ gesture: UITapGestureRecognizer){
        
        //Kiem tra thiet bi co camera ko
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showAlert()
        } else {
        //Ko co camera thi chuyen den library luon
            goToLibrary()
        }
        
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Get Image", message: "Where do you want to get image?", preferredStyle: .actionSheet)
        
        let cameraButton = UIAlertAction(title: "Camera", style: .destructive, handler: { (_) in
            self.goToCamera()
        })
        
        let photoLibraryButton = UIAlertAction(title: "Photo Library", style: .default, handler: { (_) in
            self.goToLibrary()
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
            
        })
        
        alert.addAction(cameraButton)
        alert.addAction(photoLibraryButton)
        alert.addAction(cancelButton)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func goToCamera(){
        self.presentImagePickerController(sourceType: .camera)
    }
    func goToLibrary(){
        self.presentImagePickerController(sourceType: .photoLibrary)
    }
    
    func presentImagePickerController(sourceType: UIImagePickerControllerSourceType) {
        imagePicker = UIImagePickerController()
        
        self.imagePicker?.sourceType = sourceType
        self.imagePicker?.allowsEditing = false
        self.imagePicker?.delegate = self
        self.imagePicker?.modalPresentationStyle = .currentContext
        self.present(imagePicker!, animated: true, completion: nil)
    }
    
    func getDocumentURL() -> URL {
        let doccumentsDirectoryURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        return doccumentsDirectoryURL
    }
    func getImageUrl() -> String {
        let urlImage = getDocumentURL().absoluteString + nameLanguage.text!
        return urlImage
    }
    
    
    @IBAction func saveToDatabase(_ sender: UIButton){
        
        writeImage(path: getDocumentURL(), imageName: nameLanguage.text!, image: imageLanguage.image!)
        database.insertDataBase("Language",  dict: ["LanguageName":nameLanguage.text! ,"UrlImg": getImageUrl()])
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func writeImage(path : URL, imageName : String, image : UIImage) {
        
        let newPath = path.appendingPathComponent(imageName)
        do {
            try UIImagePNGRepresentation(image)?.write(to: newPath)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
}

extension addLanguage: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        //Lay hinh anh tu PhotoLibrary
        if let mediaType = info[UIImagePickerControllerMediaType] as? String, mediaType == kUTTypeImage as String
        {
            if (info[UIImagePickerControllerReferenceURL] as? URL) != nil {
                if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
                    self.imageLanguage.image = img
                }
            } else {
                //Lay hinh anh tu camera
                if let img = info[UIImagePickerControllerOriginalImage] as? UIImage{
                    self.imageLanguage.image = img
                }
            }
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}




