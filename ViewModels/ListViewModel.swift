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
        let languageCode = Locale.current.languageCode
        
        switch name {
        case "meat, poultry":
            return languageCode == "ar" ? "لحوم ودواجن 🥩" : "Meat & Poultry 🥩"
        case "seafood":
            return languageCode == "ar" ? "مأكولات بحرية 🦐" : "Seafood 🦐"
        case "dairy":
            return languageCode == "ar" ? "منتجات الألبان 🧀" : "Dairy 🧀"
        case "fruits & vegetables":
            return languageCode == "ar" ? "فواكه وخضروات 🍇" : "Fruits & Vegetables 🍇"
        case "frozen foods":
            return languageCode == "ar" ? "أطعمة مجمدة ❄️" : "Frozen Foods ❄️"
        case "bakery":
            return languageCode == "ar" ? "مخبوزات 🍞" : "Bakery 🍞"
        case "rice, grains & pasta":
            return languageCode == "ar" ? "أرز وحبوب ومعكرونة 🌾" : "Rice, Grains & Pasta 🌾"
        case "cooking and baking supplies":
            return languageCode == "ar" ? "مستلزمات الطهي والخبز 🍲" : "Cooking and Baking Supplies 🍲"
        case "deli":
            return languageCode == "ar" ? "مأكولات معدة 🥓" : "Deli 🥓"
        case "spices & seasonings":
            return languageCode == "ar" ? "التوابل والمنكهات 🧂" : "Spices & Seasonings 🧂"
        case "condiment & sauces":
            return languageCode == "ar" ? "صلصات وتوابل 🍝" : "Condiment & Sauces 🍝"
        case "canned food":
            return languageCode == "ar" ? "أطعمة معلبة 🥫" : "Canned Food 🥫"
        case "snacks, sweets & candy":
            return languageCode == "ar" ? "وجبات خفيفة وحلويات 🍭" : "Snacks, Sweets & Candy 🍭"
        case "personal care products":
            return languageCode == "ar" ? "منتجات العناية الشخصية 🧴" : "Personal Care Products 🧴"
        case "household supplies":
            return languageCode == "ar" ? "مستلزمات منزلية 🧹" : "Household Supplies 🧹"
        case "beverages & water":
            return languageCode == "ar" ? "مشروبات ومياه 💧" : "Beverages & Water 💧"
        case "coffee & tea":
            return languageCode == "ar" ? "قهوة وشاي ☕️" : "Coffee and Tea ☕️"
        case "breakfast foods":
            return languageCode == "ar" ? "أطعمة الإفطار 🥞" : "Breakfast Foods 🥞"
        case "baby products":
            return languageCode == "ar" ? "منتجات الأطفال 🍼" : "Baby Products 🍼"
        default:
            return name
        }
    }

}
