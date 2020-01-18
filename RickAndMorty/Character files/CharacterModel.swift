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
    
    var dispatchGroup = DispatchGroup()
    var allCharacters = [Character]()
    var delegate:CharacterModelProtocol?
    
    func getCharactersFromPage(page:Int) {
        
        let nextURL = "https://rickandmortyapi.com/api/character/?page=\(page)"
        
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
                    
                    // Add the characters from one page to all characters
                    self.allCharacters += characters
                    

                    self.dispatchGroup.leave()
                    
                }
                catch {
                    
                    print("Error parsing JSON")
                }
                
            } // End of if
            
        } // End of completion handler
        
        // Start the dataTask
        dataTask.resume()
        
    }
    
    func getCharacters() {
        
        // Set up an operation queue
        let operationQueue = OperationQueue()
        
        let operation1 = BlockOperation {
            
            // Iterate through the 25 character pages in the API
            for pageNum in 1...25 {
                
                self.dispatchGroup.enter()
                self.getCharactersFromPage(page: pageNum)
                
            }
            
            // Wait until all characters from all the API pages are downloaded
            self.dispatchGroup.wait()
            
        }
        
        let operation2 = BlockOperation {
            
            // Pass the characters back to the view controller
            DispatchQueue.main.async {
                self.delegate?.charactersRetrieved(self.allCharacters)
            }
            
        }
        
        operation2.addDependency(operation1)
        operationQueue.addOperations([operation1, operation2], waitUntilFinished: false)
        
    }
    
}


