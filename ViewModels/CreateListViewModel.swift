//
//  CreateListViewModel.swift
//  TurboList
//
//  Created by Faizah Almalki on 02/05/1446 AH.
//


import Foundation
import SwiftUI
import CoreML

class CreateListViewModel: ObservableObject {
    
    @Published var isBellTapped: Bool = false
    @Published var listName: String = ""
    @Published var userInput: String = ""
    @Published var categorizedProducts: [GroceryCategory] = []
    @Published var showResults = false
    
    private var model: MyFA10? = {
        do {
            return try MyFA10(configuration: MLModelConfiguration())
        } catch {
            print("Failed to load model: \(error)")
            return nil
        }
    }()
    
    func classifyProducts() {
        guard let model = model else {
            categorizedProducts = [GroceryCategory(name: "Model not available", items: [])]
            return
        }
        
        let processedInput = preprocessInputWithNLP(userInput)
        
        let productLines = processedInput.split(separator: "\n").flatMap { line in
            line.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        }
        
        var categoryDict: [String: [GroceryItem]] = [:]
        
        for product in productLines {
            let correctedText = correctSpelling(for: product.lowercased())
            let (quantity, productName) = extractQuantity(from: correctedText)
            
            do {
                let prediction = try model.prediction(text: productName)
                let category = prediction.label
                
                if categoryDict[category] != nil {
                    categoryDict[category]?.append(GroceryItem(name: productName, quantity: quantity))
                } else {
                    categoryDict[category] = [GroceryItem(name: productName, quantity: quantity)]
                }
            } catch {
                print("Prediction error: \(error)")
                if categoryDict["Prediction Error"] != nil {
                    categoryDict["Prediction Error"]?.append(GroceryItem(name: productName, quantity: quantity))
                } else {
                    categoryDict["Prediction Error"] = [GroceryItem(name: productName, quantity: quantity)]
                }
            }
        }
        
        categorizedProducts = categoryDict.map { GroceryCategory(name: $0.key, items: $0.value) }
    }
    
    private func preprocessInputWithNLP(_ input: String) -> String {
        var processedText = input
        processedText = correctSpelling(for: processedText)
        processedText = removeStopWords(processedText)
        processedText = normalizeUnitsAndQuantities(processedText)
        return processedText
    }
    
    private func extractQuantity(from text: String) -> (Int, String) {
        var normalizedText = normalizeNumbers(in: text)
        
        let numberWords = ["one": 1, "two": 2, "three": 3, "four": 4, "five": 5, "six": 6, "seven": 7, "eight": 8, "nine": 9]
        
        for (word, number) in numberWords {
            if normalizedText.contains(word) {
                normalizedText = normalizedText.replacingOccurrences(of: word, with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                return (number, normalizedText)
            }
        }
        
        let numericParts = normalizedText.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if let quantity = Int(numericParts), quantity > 0 {
            normalizedText = normalizedText.replacingOccurrences(of: numericParts, with: "").trimmingCharacters(in: .whitespacesAndNewlines)
            return (quantity, normalizedText)
        }
        
        return (1, normalizedText)
    }

    private func normalizeNumbers(in text: String) -> String { text }
    private func correctSpelling(for text: String) -> String { text }
    private func removeStopWords(_ text: String) -> String {
        let stopWords = ["please", "the", "a", "an", "and", "of", "on", "in", "at", "for", "with", "about", "against", "between", "into", "through", "during", "before", "after", "above", "below", "to", "from", "up", "down", "out", "over", "under"]
        
        let pattern = "\\b(" + stopWords.joined(separator: "|") + ")\\b"
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        
        let range = NSRange(location: 0, length: text.utf16.count)
        let newText = regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: "")
        
        return newText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func normalizeUnitsAndQuantities(_ text: String) -> String {
        var newText = text
        let unitMappings = ["kg": "kg", "liter": "L"]
        for (englishUnit, standardUnit) in unitMappings {
            newText = newText.replacingOccurrences(of: englishUnit, with: standardUnit)
        }
        return newText
    }
}