//
//  Model.swift
//
//  Created by Faizah Almalki on 02/05/1446 AH.
//

import Foundation


struct GroceryItem: Identifiable {
    let id = UUID()  // unique identifier
    var name: String
    var quantity: Int
    var isSelected: Bool = false
}

struct GroceryCategory: Identifiable {
    let id = UUID()
    var name: String
    var items: [GroceryItem]
}


