//
//  CharacterModel.swift
//  RickAndMorty
//
//  Created by Tommy Alpert on 1/11/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import Foundation

protocol CharacterModelProtocol {
    
    func charactersRetrieved(_ characters:[Character])
}

class CharacterModel {
    
    var delegate:CharacterModelProtocol?
    
    func getCharacters() {
        
        let nextURL = "https://rickandmortyapi.com/api/character/"
        
        // Create a string url
        let stringUrl = nextURL
        
        // Create a url object
        let url = URL(string: stringUrl)
        
        // Check that it isn't nil
        guard url != nil else {
            print("URL object coudn't be created")
            return
        }
        
        // Get the URL session
        let session = URLSession.shared
        
        // Create the data task
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            
            // Completion handler
            
            // Check that there is data and there are no errors
            if data != nil && error == nil {
                
                let decoder = JSONDecoder()
                
                do {
                    
                    // Parse the json into CharacterService
                    let characterService = try decoder.decode(CharacterService.self, from: data!)
                    
                    // Get the characters
                    let characters = characterService.results!

                    // Pass it to the view controller in main thread
                    DispatchQueue.main.async {
                        self.delegate?.charactersRetrieved(characters)
                    }
                    
                }
                catch {
                    
                    print("Error parsing JSON")
                }
                
            } // End of if
            
        } // End of completion handler
        
        // Start the dataTask
        dataTask.resume()
        
    }
    
}


