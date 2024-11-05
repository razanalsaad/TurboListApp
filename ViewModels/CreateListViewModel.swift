//
//  CreateListViewModel.swift
//  TurboList
//
//  Created by Faizah Almalki on 02/05/1446 AH.
//


import Foundation
import SwiftUI
import CoreML

import CloudKit
import AuthenticationServices
class CreateListViewModel: ObservableObject {

    @Published var isBellTapped: Bool = false
    @Published var listName: String = ""
    @Published var userInput: String = ""
    @Published var categorizedProducts: [GroceryCategory] = []
    @Published var showResults = false
    private var database = CKContainer.default().publicCloudDatabase
      @Published var items: [Item] = []
      @Published var sharedLists: [SharedList] = []

    var userSession: UserSession // Store the user session
    // Initializer that accepts a UserSession
       init(userSession: UserSession) {
           self.userSession = userSession
           // Any additional setup
       }
    private var model: MyFA10? = {
        do {
            return try MyFA10(configuration: MLModelConfiguration())
        } catch {
            print("Failed to load model: \(error)")
            return nil
        }
    }()
    // MARK: - Fetch Items for a Specific List
     func fetchItems(for listId: CKRecord.Reference) {
         let query = CKQuery(recordType: "Item", predicate: NSPredicate(format: "list_id == %@", listId))
         
         database.perform(query, inZoneWith: nil) { [weak self] records, error in
             if let error = error {
                 print("Error fetching items: \(error.localizedDescription)")
                 return
             }
             guard let records = records else { return }
             DispatchQueue.main.async {
                 self?.items = records.map { Item(record: $0) }
             }
         }
     }
    // MARK: - Save a New Item
    func saveItem(name: String, quantity: Int64, listId: CKRecord.Reference, categories: [String]) {
        let newItem = Item(itemId: UUID(), nameItem: name, numberOfItem: quantity, listId: listId, categories: categories)
        
        // Create a new CKRecord using the `toRecord` method
        let record = newItem.toRecord()

        // Save the record to CloudKit
        database.save(record) { [weak self] savedRecord, error in
            if let error = error {
                print("Error saving item: \(error.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async {
                if let savedRecord = savedRecord {
                    self?.items.append(Item(record: savedRecord))
                }
            }
        }
    }


    
    // MARK: - Fetch Shared Lists
    func fetchSharedLists(for userId: CKRecord.Reference) {
        let query = CKQuery(recordType: "SharedList", predicate: NSPredicate(format: "owner_id == %@", userId))
        
        database.perform(query, inZoneWith: nil) { [weak self] records, error in
            if let error = error {
                print("Error fetching shared lists: \(error.localizedDescription)")
                return
            }
            guard let records = records else { return }
            DispatchQueue.main.async {
                self?.sharedLists = records.map { SharedList(record: $0) }
            }
        }
    }
    // MARK: - Share a List
    func shareList(ownerId: CKRecord.Reference, listId: CKRecord.Reference) {
        // Initialize a new SharedList
        let sharedList = SharedList(ownerId: ownerId, listId: listId)
        
        // Convert the SharedList to a CKRecord
        let record = sharedList.toRecord()

        // Save the CKRecord to CloudKit
        database.save(record) { [weak self] savedRecord, error in
            if let error = error {
                print("Error sharing list: \(error.localizedDescription)")
                return
            }

            DispatchQueue.main.async {
                if let savedRecord = savedRecord {
                    // Initialize a new SharedList from the saved CKRecord and append it to sharedLists
                    self?.sharedLists.append(SharedList(record: savedRecord))
                }
            }
        }
    }

  

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

extension CreateListViewModel {
    
    func saveListToCloudKit(userSession: UserSession) {
        let newList = CKRecord(recordType: "List")
        newList["list_name"] = listName as CKRecordValue
        newList["isShared"] = false as CKRecordValue // or true, depending on the logic
        newList["created_at"] = Date() as CKRecordValue
        newList["updated_at"] = Date() as CKRecordValue
        newList["list_total_item"] = 0 as CKRecordValue // assuming new list has no items yet
        
        // Use the user ID from UserSession
        if let userID = userSession.userID {
            let userReference = CKRecord.Reference(recordID: CKRecord.ID(recordName: userID), action: .deleteSelf)
            newList["owned_id"] = userReference
        }
        
        CKContainer.default().publicCloudDatabase.save(newList) { record, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error saving list: \(error.localizedDescription)")
                } else {
                    print("List saved successfully")
                }
            }
        }
    }
}

