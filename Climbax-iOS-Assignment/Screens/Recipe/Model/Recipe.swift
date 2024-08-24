//
//  Model.swift
//  Climbax-iOS-Assignment
//
//  Created by Govind Sen on 24/08/24.
//

import Foundation

struct RecipeResponse: Codable {
    let recipes: [Recipe]
}

struct Recipe: Codable {
    let name: String
    let cuisine: String
    let image: String
    let rating: Double
}
