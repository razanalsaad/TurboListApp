//
//  Item.swift
//  TurboList
//
//  Created by Rahaf ALghuraibi on 02/05/1446 AH.
//

import SwiftUI
import CloudKit
import Combine
import CloudKit
import CloudKit

struct Item {
    var itemId: UUID
    var nameItem: String
    var numberOfItem: Int64
    var listId: CKRecord.Reference
    var categories: [String] // Array of categories

    // Convert Item to CKRecord for saving to CloudKit
    func toRecord() -> CKRecord {
        let record = CKRecord(recordType: "Item")
        record["item_id"] = itemId.uuidString as CKRecordValue
        record["name_item"] = nameItem as CKRecordValue
        record["number_of_item"] = numberOfItem as CKRecordValue
        record["list_id"] = listId
        record["categories"] = categories as CKRecordValue // Save categories array
        return record
    }
    
    // Initialize Item from a CKRecord
    init(record: CKRecord) {
        self.itemId = UUID(uuidString: record["item_id"] as! String) ?? UUID()
        self.nameItem = record["name_item"] as! String
        self.numberOfItem = record["number_of_item"] as! Int64
        self.listId = record["list_id"] as! CKRecord.Reference
        self.categories = record["categories"] as? [String] ?? []
    }

    // Convenience initializer for new Items (no CKRecord yet)
    init(itemId: UUID = UUID(), nameItem: String, numberOfItem: Int64, listId: CKRecord.Reference, categories: [String]) {
        self.itemId = itemId
        self.nameItem = nameItem
        self.numberOfItem = numberOfItem
        self.listId = listId
        self.categories = categories
    }
}
