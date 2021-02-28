//
//  ViewController.swift
//  bokete
//
//  Created by macbook on 2021/02/27.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import Photos

class ViewController: UIViewController {

    @IBOutlet weak var odaiImageView: UIImageView!
    
    
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var serchTextField: UITextField!
    
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextView.layer.cornerRadius = 20.0
        PHPhotoLibrary.requestAuthorization { (status) in
            switch(status){
            case .authorized: break
            case .notDetermined:
                break
            case .restricted:
                break
            case .denied:
                break
            case .limited:
                break
            @unknown default:
                break
            }
        }
        
        getImages(keyword: "funny")
    }
    
    func getImages(keyword:String){
        let url = "https://pixabay.com/api/?key=20456200-1604fddc61296cedb13318c50&q=\(keyword)"
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success:
                let json:JSON = JSON(response.data as Any)
                print("kominato")
                print(json)
                var imageString = json["hits"][self.count]["webformatURL"].string
                
                
                if imageString == nil {
                    print("dfg")
                    imageString = json["hits"][0]["webformatURL"].string
                }
                self.odaiImageView.sd_setImage(with: URL(string: imageString!), completed: nil)
            case .failure(let error):
                print(error)
            }
        }
    }

    
    @IBAction func nextOdai(_ sender: Any) {
        count = count + 1
        if serchTextField.text == ""{
            getImages(keyword: "funny")
        } else {
            getImages(keyword: serchTextField.text!)
        }
    }
    
    
    @IBAction func serchAction(_ sender: Any) {
        count = 0
        if serchTextField.text == ""{
            getImages(keyword: "funny")
        } else {
            getImages(keyword: serchTextField.text!)
        }
    }
    
    
    @IBAction func next(_ sender: Any) {
        performSegue(withIdentifier: "next", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let shareVC = segue.destination as? ShareViewController
        shareVC?.commentString = commentTextView.text
        
        shareVC?.resultImage = odaiImageView.image!
    }
    
}

