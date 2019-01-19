//
//  ViewController.swift
//  FlowersGuru
//
//  Created by TRUNG NGUYEN on 1/18/19.
//  Copyright © 2019 TRUNG NGUYEN. All rights reserved.
//

import UIKit
import CoreML
import Vision
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    let wikipediaURl = "https://en.wikipedia.org/w/api.php"
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            
            guard let convertedCIImage = CIImage(image: userPickedImage) else {fatalError("cannot convert to CIImage")}
            detect(image: convertedCIImage)
            
            imageView.image = userPickedImage
            
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage){
        
        guard let model = try? VNCoreMLModel(for: FlowerClassifier().model) else {fatalError("cannot import model")}
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let classification = request.results?.first as? VNClassificationObservation else { fatalError("Could not classify image")}
            
            self.navigationItem.title = classification.identifier.capitalized
            self.requestInfo(flowerName: classification.identifier)
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        }
        catch{
            print(error)
        }
        
    }
    
    func requestInfo(flowerName: String){
        let parameters : [String:String] = [
            "format" : "json",
            "action" : "query",
            "prop" : "extracts",
            "exintro" : "",
            "explaintext" : "",
            "titles" : flowerName,
            "indexpageids" : "",
            "redirects" : "1",
            ]
        Alamofire.request(wikipediaURl, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                print("Got the wikipedia info")
                print(JSON(response.result.value!))
                
                let flowerJSON : JSON = JSON(response.result.value!)
                let pageid = flowerJSON["query"]["pageids"][0].stringValue
                let flowerDescription = flowerJSON["query"]["pages"][pageid]["extract"].stringValue
                
                self.label.text = flowerDescription
                
                
            } else {
                print("Error geting response's result")
            }
        }
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker,animated: true, completion: nil)
        
    }
}

