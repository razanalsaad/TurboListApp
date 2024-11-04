//
//  Model.swift
//
//  Created by Faizah Almalki on 02/05/1446 AH.
//

import Foundation

struct GroceryItem: Identifiable {
    let id = UUID()
    let name: String
    var quantity: Int
}

struct GroceryCategory: Identifiable {
    let id = UUID()
    let name: String
    var items: [GroceryItem]
}
