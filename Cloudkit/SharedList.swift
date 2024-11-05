//
//  SharedList.swift
//  TurboList
//
//  Created by Rahaf ALghuraibi on 02/05/1446 AH.
//


import SwiftUI
import CloudKit
import Combine
import CloudKit

struct SharedList {
    var sharedListId: UUID
    var ownerId: CKRecord.Reference
    var listId: CKRecord.Reference

    // Convert SharedList to CKRecord for saving to CloudKit
    func toRecord() -> CKRecord {
        let record = CKRecord(recordType: "SharedList")
        record["shared_list_id"] = sharedListId.uuidString as CKRecordValue
        record["owner_id"] = ownerId
        record["list_id"] = listId
        return record
    }

    // Initialize SharedList from a CKRecord
    init(record: CKRecord) {
        self.sharedListId = UUID(uuidString: record["shared_list_id"] as! String) ?? UUID()
        self.ownerId = record["owner_id"] as! CKRecord.Reference
        self.listId = record["list_id"] as! CKRecord.Reference
    }

    // Convenience initializer for new SharedList (no CKRecord yet)
    init(sharedListId: UUID = UUID(), ownerId: CKRecord.Reference, listId: CKRecord.Reference) {
        self.sharedListId = sharedListId
        self.ownerId = ownerId
        self.listId = listId
    }
}
