//
//  CharacterService.swift
//  RickAndMorty
//
//  Created by Tommy Alpert on 1/11/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import Foundation

struct CharacterService: Decodable {
    
    var info: infolist?
    var results: [Character]?
    
}

struct infolist: Decodable {
    
    var count: Int?
    var pages: Int?
    var next: String?
    var prev: String?
    
}
