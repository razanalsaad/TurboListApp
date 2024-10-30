//
//  Post.swift
//  TurboList
//
//  Created by Rahaf ALghuraibi on 24/04/1446 AH.
//
//
//import Foundation
//import CloudKit
//
//import CloudKit
//
//func createListRecord(listName: String, userReference: CKRecord.Reference) {
//    let listRecord = CKRecord(recordType: "List")
//    listRecord["list_name"] = listName
//    listRecord["owned_id"] = userReference
//    listRecord["isShared"] = false
//    listRecord["created_at"] = Date()
//    listRecord["updated_at"] = Date()
//    listRecord["list_total_item"] = 0 as Int64
//    
//    let publicDatabase = CKContainer.default().publicCloudDatabase
//    publicDatabase.save(listRecord) { record, error in
//        if let error = error {
//            print("Error saving List record: \(error.localizedDescription)")
//        } else {
//            print("List record saved successfully!")
//        }
//    }
//}
//
////// Function to create and save a record
////func saveListRecord() {
////    // Get the CloudKit database (private, public, or shared)
////    let database = CKContainer.default().privateCloudDatabase
////    
////    // Create a new record of type "List"
////    let record = CKRecord(recordType: "List")
////    
////    // Set the values for the fields in your record
////    record["list_name"] = "My Shopping List" as CKRecordValue
////    record["isShared"] = false as CKRecordValue // Boolean field for isShared
////
////    // Save the record in the CloudKit database
////    database.save(record) { (record, error) in
////        if let error = error {
////            print("Error saving record: \(error.localizedDescription)")
////        } else {
//            print("Record saved successfully!")
//        }
//    }
//}
//
//func fetchListRecord(recordID: CKRecord.ID) {
//    let database = CKContainer.default().privateCloudDatabase
//    
//    database.fetch(withRecordID: recordID) { (record, error) in
//        if let error = error {
//            print("Error fetching record: \(error.localizedDescription)")
//        } else if let record = record {
//            let isShared = record["isShared"] as? Bool ?? false
//            print("Is Shared: \(isShared)")
//        }
//    }
//}
//func updateListRecord(recordID: CKRecord.ID) {
//    let database = CKContainer.default().privateCloudDatabase
//    
//    // Fetch the record first
//    database.fetch(withRecordID: recordID) { (record, error) in
//        if let error = error {
//            print("Error fetching record: \(error.localizedDescription)")
//        } else if let record = record {
//            // Modify the Boolean field
//            record["isShared"] = true as CKRecordValue
//            
//            // Save the changes back to CloudKit
//            database.save(record) { (record, error) in
//                if let error = error {
//                    print("Error updating record: \(error.localizedDescription)")
//                } else {
//                    print("Record updated successfully!")
//                }
//            }
//        }
//    }
//}
//
