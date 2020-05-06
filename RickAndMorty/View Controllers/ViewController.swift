//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Tommy Alpert on 1/11/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
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
        getCharacters()
        
        // Search Controller Set Up
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Characters"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
// MARK: - Segues
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

// MARK: - Table View
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

// MARK: - Search Bar
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

// MARK: - Alamofire
extension ViewController {
    
    func getCharacters() {
        
        let dispatchGroup = DispatchGroup()
        
        for page in 1...25 {
            
            let url = "https://rickandmortyapi.com/api/character/?page=\(page)"
            
            dispatchGroup.enter()
            
            AF.request(url).validate()
                .responseDecodable(of: CharacterService.self)  { (response) in
                    guard let charServ = response.value else { return }
                    self.characters.append(contentsOf: charServ.results!)
                    self.tableview.reloadData()
            }
            
            dispatchGroup.leave()
        }
    }
    
}


