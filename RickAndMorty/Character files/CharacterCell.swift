//
//  CharacterCell.swift
//  RickAndMorty
//
//  Created by Tommy Alpert on 1/11/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import UIKit

class CharacterCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var characterPic: UIImageView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var characterToDisplay: Character?
    
    func displayCharacter(_ character: Character) {
        
        // Clean up the cell before displaying the character
        nameLabel.text = ""
        nameLabel.alpha = 0
        characterPic.image = nil
        characterPic.alpha = 0
        
        // Keep a refrence to the character
        characterToDisplay = character
        
        // Set the name label text
        nameLabel.text = characterToDisplay!.name
        
        // Animate the name label into view
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            
            self.nameLabel.alpha = 1
            
        }, completion: nil)
        
        // Download and display the image
        
        // Check that the article has an image
        guard characterToDisplay!.image != nil else {
            return
        }
        
        // Create the url String
        let urlString = characterToDisplay!.image!
        
        // Check the cache manager before downloading any image data
        if let imageData = CacheManager.retrieveData(urlString) {
            
            // There is imageData, set the characterPic
            characterPic.image = UIImage(data: imageData)
            
            // Animate the image into view
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                
                self.characterPic.alpha = 1
                
            }, completion: nil)
            
            return
        }
        
        // Create the url
        let url = URL(string: urlString)
        
        // Check that the url isn't nil
        guard url != nil else{
            print("Coudn't create url object")
            return
        }
        
        // Get a URLsession
        let session = URLSession.shared
        // Create a dataTask
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            
            // Check if there are no errors
            if data != nil && error == nil {
                
                // Save the data into the cache
                CacheManager.saveData(urlString, data!)
                
                // Check if the urlstring sent to retrieve data matches the character the cell is set to display
                if self.characterToDisplay!.image == urlString {
                    
                    DispatchQueue.main.async {
                        
                        // Display the image data in the image view
                        self.characterPic.image = UIImage(data: data!)
                        
                        // Animate the label into view
                        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
                            
                            self.characterPic.alpha = 1
                            
                        }, completion: nil)
                    }
                } // End of if
            }
            
        }
        
        // Start the data task
        dataTask.resume()
        
        // Add border to character pic
        characterPic.layer.borderColor = UIColor.black.cgColor
        characterPic.layer.borderWidth = 4
        characterPic.layer.cornerRadius = 5
        backgroundImage.backgroundColor = UIColor(patternImage: UIImage(named: "cell background")!)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
