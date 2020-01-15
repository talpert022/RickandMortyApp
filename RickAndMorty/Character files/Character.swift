//
//  Character.swift
//  RickAndMorty
//
//  Created by Tommy Alpert on 1/11/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import Foundation

struct Character: Decodable {
    
    var id: Int?
    var name: String?
    var status: String?
    var species: String?
    var type: String?
    var gender: String?
    var origin: Place?
    var location: Place?
    var image: String?
    var episode: [String]?
    var url: String?
    var created: String?
    
}

struct Place: Decodable {
    
    var name: String?
    var url: String?
    
}
