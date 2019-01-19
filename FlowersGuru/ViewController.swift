//
//  ViewController.swift
//  FlowersGuru
//
//  Created by TRUNG NGUYEN on 1/18/19.
//  Copyright © 2019 TRUNG NGUYEN. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        
 
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let userPickedImage = info[UIImagePickerController.InfoKey.editedImage]
        
        imageView.image = userPickedImage as? UIImage
        imagePicker.dismiss(animated: true, completion: nil)
        
        
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {

        present(imagePicker,animated: true, completion: nil)
        
    }
}

