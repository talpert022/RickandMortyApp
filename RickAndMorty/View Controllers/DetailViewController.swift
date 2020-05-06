//
//  DetailViewController.swift
//  RickAndMorty
//
//  Created by Tommy Alpert on 1/13/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {

    var character: Character?
    
    // IB outlets
    

    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var episodeLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var originLabel: UILabel!
    
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var speciesLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the delegate property of the scroll view to self
        scrollView.delegate = self
        viewSetUP()
    }
    
    func viewSetUP() {
        
        // Set labels
        nameLabel.text = character!.name!
        descriptionLabel.text = character!.type!
        originLabel.text = character!.origin!.name!
        locationLabel.text = character!.location!.name!
        genderLabel.text = character!.gender!
        statusLabel.text = character!.status!
        speciesLabel.text = character!.species!
        
        // Background image on the view
        let rand = Int.random(in: 1...3)
        backgroundImage.backgroundColor = UIColor(patternImage: UIImage(named: "Detail\(rand)")!)
        
        // Set character image
        let urlString = character!.image!
        
        // Check the cache manager before downloading any image data
        if let imageData = CacheManager.retrieveData(urlString) {
            
            // There is imageData, set the characterPic
            imageView.image = UIImage(data: imageData)
            
            return

        }
        
        
        let url = URL(string: urlString)
        
        guard url != nil else {
            return
        }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            
            // Check if there are no errors
            if data != nil && error == nil {
                
                DispatchQueue.main.async {
                    
                    self.imageView.image = UIImage(data: data!)
                    
                }
            }
        }
        dataTask.resume()
    }
    
}

extension DetailViewController: UIScrollViewDelegate {
    
}
