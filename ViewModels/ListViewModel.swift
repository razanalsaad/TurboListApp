//
//  ListViewModel.swift
//  TurboList
//
//  Created by Faizah Almalki on 02/05/1446 AH.
//

import Foundation

import SwiftUI

class ListViewModel: ObservableObject {
    @Published var categories: [GroceryCategory]
    
    init(categories: [GroceryCategory]) {
        self.categories = categories
    }
    
    func increaseQuantity(for categoryIndex: Int, itemIndex: Int) {
        categories[categoryIndex].items[itemIndex].quantity += 1
    }
    
    func decreaseQuantity(for categoryIndex: Int, itemIndex: Int) {
        if categories[categoryIndex].items[itemIndex].quantity > 0 {
            categories[categoryIndex].items[itemIndex].quantity -= 1
        }
    }
    
    func formattedCategoryName(_ name: String) -> String {
        switch name {
        case "meat, poultry":
            return "Meat & Poultry 🥩"
        case "seafood":
            return "Seafood 🦐"
        case "dairy":
            return "Dairy 🧀"
        case "fruits & vegetables":
            return "Fruits & Vegetables 🍇"
        case "frozen foods":
            return "Frozen Foods ❄️"
        case "bakery":
            return "Bakery 🍞"
        case "rice, grains & pasta":
            return "Rice, Grains & Pasta 🌾"
        case "cooking and baking supplies":
            return "Cooking and Baking Supplies 🍲"
        case "deli":
            return "Deli 🥓"
        case "spices & seasonings":
            return "Spices & Seasonings 🧂"
        case "condiment & sauces":
            return "Condiment & Sauces 🍝"
        case "canned food":
            return "Canned Food 🥫"
        case "snacks, sweets & candy":
            return "Snacks, Sweets & Candy 🍭"
        case "personal care products":
            return "Personal Care Products 🧴"
        case "household supplies":
            return "Household Supplies 🧹"
        case "beverages & water":
            return "Beverages & Water 💧"
        case "coffee & tea":
            return "Coffee and Tea ☕️"
        case "breakfast foods":
            return "Breakfast Foods 🥞"
        case "baby products":
            return "Baby Products 🍼"
        default:
            return name
        }
    }
}
