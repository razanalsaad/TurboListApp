//
//  SharedList.swift
//  TurboList
//
//  Created by Rahaf ALghuraibi on 02/05/1446 AH.
//


import SwiftUI
import CloudKit
import Combine
// MARK: - SharedList Model
struct SharedList {
    var recordID: CKRecord.ID?
    var sharedListId: UUID
    var ownerId: CKRecord.Reference // Reference to the user who shared the list
    var listId: CKRecord.Reference  // Reference to the list being shared

    func toRecord() -> CKRecord {
        let record = CKRecord(recordType: "SharedList")
        record["id"] = sharedListId.uuidString as CKRecordValue
        record["owner_id"] = ownerId
        record["list_id"] = listId
        return record
    }

    init(record: CKRecord) {
        self.recordID = record.recordID
        self.sharedListId = UUID(uuidString: record["id"] as! String) ?? UUID()
        self.ownerId = record["owner_id"] as! CKRecord.Reference
        self.listId = record["list_id"] as! CKRecord.Reference
    }
}
