//
//  CloudKitHelper.swift
//  TurboList
//
//  Created by Faizah Almalki on 07/05/1446 AH.
//

import Foundation
import Foundation
import CloudKit

class CloudKitHelper {
    static func saveItem(name: String, quantity: Int64, listId: CKRecord.Reference, categories: [String]) {
        let newItemRecord = CKRecord(recordType: "Item")
        newItemRecord["item_id"] = UUID().uuidString as CKRecordValue
        newItemRecord["name_item"] = name as CKRecordValue
        newItemRecord["number_of_item"] = quantity as CKRecordValue
        newItemRecord["list_id"] = listId
        newItemRecord["categories"] = categories as CKRecordValue
        
        CKContainer.default().publicCloudDatabase.save(newItemRecord) { savedRecord, error in
            if let error = error {
                print("Error saving item: \(error.localizedDescription)")
            } else {
                print("Item saved successfully with ID: \(savedRecord!.recordID)")
            }
        }
    }}
