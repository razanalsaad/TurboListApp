//
//  List.swift
//  TurboList
//
//  Created by Rahaf ALghuraibi on 02/05/1446 AH.
//

import SwiftUI
import CloudKit
import Combine
// MARK: - List Model
struct List {
    var recordID: CKRecord.ID?
    var listId: UUID
    var listName: String
    var isShared: Bool
    var ownedId: CKRecord.Reference // Reference to the user who owns the list
    var createdAt: Date
    var updatedAt: Date
    var totalItems: Int64

    func toRecord() -> CKRecord {
        let record = CKRecord(recordType: "List")
        record["list_id"] = listId.uuidString as CKRecordValue
        record["list_name"] = listName as CKRecordValue
        record["isShared"] = isShared as CKRecordValue
        record["owned_id"] = ownedId
        record["created_at"] = createdAt as CKRecordValue
        record["updated_at"] = updatedAt as CKRecordValue
        record["list_total_item"] = totalItems as CKRecordValue
        return record
    }

    init(record: CKRecord) {
        self.recordID = record.recordID
        self.listId = UUID(uuidString: record["list_id"] as! String) ?? UUID()
        self.listName = record["list_name"] as! String
        self.isShared = record["isShared"] as! Bool
        self.ownedId = record["owned_id"] as! CKRecord.Reference
        self.createdAt = record["created_at"] as! Date
        self.updatedAt = record["updated_at"] as! Date
        self.totalItems = record["list_total_item"] as! Int64
    }
}
