//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Tommy Alpert on 1/11/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    var model = CharacterModel()
    var characters = [Character]()
    var pageNum = 2
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredCharacters: [Character] = []
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view controller as the delegate and datasource of table view
        tableview.delegate = self
        tableview.dataSource = self
        
        // Get the character from character model
        model.delegate = self
        model.getCharacters()
        
        // Search Controller Set Up
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Characters"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Detect the index path the user selected
        let indexPath = tableview.indexPathForSelectedRow
        
        guard indexPath != nil else {
            return
        }
        
        // Get the article the user tapped on
        let character: Character
        if isFiltering {
            character = filteredCharacters[indexPath!.row]
        } else {
            character = characters[indexPath!.row]
        }
        
        // Get a refrence to the detail view controller
        let detailVC = segue.destination as! DetailViewController
        
        // Pass the character to the detai
        detailVC.character = character
        
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filteredCharacters.count
        }
        
        return characters.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get a cell
        let cell = tableview.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as! CharacterCell
        
        // Get the character that the cell requests
        let character: Character
        if isFiltering {
            character = filteredCharacters[indexPath.row]
        } else {
            character = characters[indexPath.row]
        }
        
        // Customize it
        cell.displayCharacter(character)
        
        // Return the cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // User has just selected a row, trigger to go to detail
        performSegue(withIdentifier: "goToDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 125.0
        
    }
    
}

extension ViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    // Filters characters based on search text
    func filterContentForSearchText(_ searchText: String) {
        
        filteredCharacters = characters.filter { (car : Character) -> Bool in
            return car.name!.lowercased().contains(searchText.lowercased())
        }
        
        tableview.reloadData()
        
    }
    
}
    

extension ViewController: CharacterModelProtocol {
    
    func charactersRetrieved(_ characters: [Character]) {
        
        // Set the articles property of the vc to the articles passed back from the model
        self.characters = characters
        
        // Refresh the tableview
        tableview.reloadData()
        
    }
    
}

