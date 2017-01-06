//
//  AddWordVC.swift
//  LearnLanguage
//
//  Created by iOS Student on 11/18/16.
//  Copyright © 2016 PIRATE. All rights reserved.
//

import UIKit
import MobileCoreServices   //De su dung kUTTypeImage
import AVFoundation

class AddWordVC: UIViewController, AVAudioRecorderDelegate {
    
    let database = DataBase.sharedInstance
    var languageid: Int!
    var imagePicker: UIImagePickerController?
    

    @IBOutlet weak var nameWord: UITextField!
    @IBOutlet weak var wordForm: UITextField!
    @IBOutlet weak var Mean: UITextField!
    @IBOutlet weak var transcription: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var recordButton: UIButton!
    
    @IBAction func recordBtn(_ sender: AnyObject) {
        let recorderVC = RecordVC(nibName: "RecordVC", bundle: nil)
        
        recorderVC.fileName = self.nameWord.text
        navigationController?.pushViewController(recorderVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        addTapToImage()
    }
    func addTapToImage(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(getImage(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
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
    
    @IBAction func saveWord(_ sender: AnyObject) {
        
        writeImage(path: getDocumentURL(), imageName: nameWord.text!, image: imageView.image!)
        saveToDatabase()
        
        _ = navigationController?.popViewController(animated: true)
    }
    func saveToDatabase(){
        database.insertDataBase("WORD", dict: ["NameWord":nameWord.text!, "Mean":Mean.text!, "WordForm":wordForm.text!, "Image":"", "Bool":"1", "LANGUAGEID":"\(languageid!)"])
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

    extension AddWordVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
        {
            //Lay hinh anh tu PhotoLibrary
            if let mediaType = info[UIImagePickerControllerMediaType] as? String, mediaType == kUTTypeImage as String
            {
                if (info[UIImagePickerControllerReferenceURL] as? URL) != nil {
                    if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
                        self.imageView.image = img
                    }
                } else {
                    //Lay hinh anh tu camera
                    if let img = info[UIImagePickerControllerOriginalImage] as? UIImage{
                        self.imageView.image = img
                    }
                }
            }
            
            dismiss(animated: true, completion: nil)
          
        }

        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
        
}

