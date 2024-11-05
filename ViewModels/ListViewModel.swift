//
//  ListViewModel.swift
//  TurboList
//
//  Created by Faizah Almalki on 02/05/1446 AH.
//

import Foundation

import SwiftUI
import CloudKit
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
    func toggleItemSelection(for categoryIndex: Int, itemIndex: Int) {
        categories[categoryIndex].items[itemIndex].isSelected.toggle()
        reorderCategories()
    }
    func shareList() {
        let listURL = URL(string: "https://yourapp.com/sharelist/1234") // Replace with actual URL generation logic
        let activityVC = UIActivityViewController(activityItems: [listURL!], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
    func saveToFavorites() {
        let recordID = CKRecord.ID(recordName: "YourRecordID")
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { record, error in
            if let record = record {
                record["isFavorite"] = true as CKRecordValue // Mark as favorite
                
                CKContainer.default().publicCloudDatabase.save(record) { savedRecord, error in
                    if let error = error {
                        print("Error saving to favorites: \(error)")
                    } else {
                        print("List saved to favorites")
                    }
                }
            }
        }
    }

    func deleteListAndMoveToMain() {
        let recordID = CKRecord.ID(recordName: "YourRecordID")
        CKContainer.default().publicCloudDatabase.delete(withRecordID: recordID) { recordID, error in
            if let error = error {
                print("Failed to delete: \(error)")
            } else {
                // Navigate to MainTabView
                DispatchQueue.main.async {
                    // Assuming you have a navigation structure to go back to MainTabView
                    // Example:
                    UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: MainTabView())
                }
            }
        }
    }

    private func reorderCategories() {
         let completedCategories = categories.filter { category in
             category.items.allSatisfy { $0.isSelected }
         }
         let incompleteCategories = categories.filter { category in
             !category.items.allSatisfy { $0.isSelected }
         }
         categories = incompleteCategories + completedCategories
     }
    func editList(newListName: String, newItems: [GroceryItem]) {
        let recordID = CKRecord.ID(recordName: "YourRecordID")
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { record, error in
            if let record = record {
                record["list_name"] = newListName as CKRecordValue
                // Update other fields if necessary
                
                CKContainer.default().publicCloudDatabase.save(record) { savedRecord, error in
                    if let error = error {
                        print("Failed to update: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            // Send a notification to CreateListView with the previous list data
                            NotificationCenter.default.post(
                                name: .navigateToCreateListView,
                                object: newItems, // Pass the items array
                                userInfo: ["listName": newListName] // Pass the list name
                            )
                            print("List updated successfully")
                        }
                    }
                }
            }
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

//
//extension ListViewModel {
//    private var database: CKDatabase {
//        return CKContainer.default().privateCloudDatabase
//    }
//    
//    // Fetch all lists from CloudKit
//    func fetchListsFromCloudKit() {
//        let query = CKQuery(recordType: "List", predicate: NSPredicate(value: true))
//        
//        database.perform(query, inZoneWith: nil) { records, error in
//            DispatchQueue.main.async {
//                if let records = records {
//                    self.categories = records.map { record in
//                        // Assuming you want to categorize items by list name
//                        let listName = record["list_name"] as! String
//                        let items = self.fetchItemsForList(listId: record.recordID)
//                        return GroceryCategory(name: listName, items: items)
//                    }
//                } else if let error = error {
//                    print("Error fetching lists: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//    
//    // Fetch items for a specific list
//    func fetchItemsForList(listId: CKRecord.ID) -> [GroceryItem] {
//        // Add logic to fetch items based on the listId from CloudKit
//        // Placeholder logic for now
//        return [
//            GroceryItem(name: "Placeholder Item", quantity: 1)  // Example item
//        ]
//    }
//    
//    // Save a new list to CloudKit
//    func saveListToCloudKit(_ list: List) {
//        let record = list.toRecord()
//        
//        database.save(record) { savedRecord, error in
//            DispatchQueue.main.async {
//                if let savedRecord = savedRecord {
//                    let newList = List(record: savedRecord)
//                    let newCategory = GroceryCategory(name: newList.listName, items: [])
//                    self.categories.append(newCategory)
//                    print("save list ")
//                } else if let error = error {
//                    print("Error saving list: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//    
//    // Update an existing list in CloudKit
//    func updateListInCloudKit(_ list: List) {
//        guard let recordID = list.recordID else { return }
//        
//        database.fetch(withRecordID: recordID) { fetchedRecord, error in
//            if let fetchedRecord = fetchedRecord {
//                fetchedRecord["list_name"] = list.listName as CKRecordValue
//                fetchedRecord["isShared"] = list.isShared as CKRecordValue
//                fetchedRecord["updated_at"] = Date() as CKRecordValue
//                
//                self.database.save(fetchedRecord) { updatedRecord, error in
//                    DispatchQueue.main.async {
//                        if let updatedRecord = updatedRecord {
//                            if let index = self.categories.firstIndex(where: { $0.name == list.listName }) {
//                               // self.categories[index].name = list.listName
//                            }
//                        } else if let error = error {
//                            print("Error updating list: \(error.localizedDescription)")
//                        }
//                    }
//                }
//            } else if let error = error {
//                print("Error fetching list to update: \(error.localizedDescription)")
//            }
//        }
//    }
//    
//    // Delete a list from CloudKit
//    func deleteListFromCloudKit(_ list: List) {
//        guard let recordID = list.recordID else { return }
//        
//        database.delete(withRecordID: recordID) { deletedRecordID, error in
//            DispatchQueue.main.async {
//                if let deletedRecordID = deletedRecordID {
//                    self.categories.removeAll { $0.name == list.listName }
//                } else if let error = error {
//                    print("Error deleting list: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//    // Save a new list to CloudKit
//      func saveListToCloudKit(listName: String, isShared: Bool) {
//          let newList = CKRecord(recordType: "List")
//          newList["list_name"] = listName as CKRecordValue
//          newList["isShared"] = isShared as CKRecordValue
//          newList["created_at"] = Date() as CKRecordValue
//          newList["updated_at"] = Date() as CKRecordValue
//
//          database.save(newList) { record, error in
//              DispatchQueue.main.async {
//                  if let record = record {
//                      print("List saved successfully with name: \(listName)")
//                      // Optionally update local list if needed
//                  } else if let error = error {
//                      print("Error saving list: \(error.localizedDescription)")
//                  }
//              }
//          }
//      }
//}
//
