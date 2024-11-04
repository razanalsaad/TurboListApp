//
//  Item.swift
//  TurboList
//
//  Created by Rahaf ALghuraibi on 02/05/1446 AH.
//

import SwiftUI
import CloudKit
import Combine
// MARK: - Item Model
struct Item {
    var recordID: CKRecord.ID?
    var itemId: UUID
    var nameItem: String
    var numberOfItem: Int64
    var listId: CKRecord.Reference // Reference to the list it belongs to
    var category: String

    func toRecord() -> CKRecord {
        let record = CKRecord(recordType: "Item")
        record["item_id"] = itemId.uuidString as CKRecordValue
        record["name_item"] = nameItem as CKRecordValue
        record["number_of_item"] = numberOfItem as CKRecordValue
        record["list_id"] = listId
        record["category"] = category as CKRecordValue
        return record
    }

    init(record: CKRecord) {
        self.recordID = record.recordID
        self.itemId = UUID(uuidString: record["item_id"] as! String) ?? UUID()
        self.nameItem = record["name_item"] as! String
        self.numberOfItem = record["number_of_item"] as! Int64
        self.listId = record["list_id"] as! CKRecord.Reference
        self.category = record["category"] as! String
    }
}

