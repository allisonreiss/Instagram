//
//  CaptureViewController.swift
//  Instagram
//
//  Created by Allison Reiss on 12/8/17.
//  Copyright © 2017 Allison Reiss. All rights reserved.
//

import UIKit

class CaptureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private var imagePickerController: UIImagePickerController!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage

        // show the picture on the capture page
        photoImageView.image = originalImage
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onAddPhoto(_ sender: Any) {
        print("I see that you tapped yo")
        
        //show image picker
        self.present(imagePickerController, animated: true, completion: nil)
    }

    
    func resize(photo: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = photo
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    @IBAction func onPost(_ sender: Any) {
        // Set the caption and photo
        let caption = captionTextField.text
        let postPic = resize(photo: self.photoImageView.image!, newSize: CGSize(width:290, height:290))
        
        // Post the photo and caption
        Post.postUserImage(photo: postPic, caption: caption) { (success: Bool, error: Error?) in
            if success {
                print("Yayyyy photo posted!")
                // go back to Home Feed
                self.tabBarController?.selectedIndex = 0
            } else {
                print(error?.localizedDescription ?? "Photo not posted")
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
