//
//  User.swift
//  TurboList
//
//  Created by Rahaf ALghuraibi on 24/04/1446 AH.
//
//import Foundation
//import CloudKit
//
//struct User: Identifiable, Hashable {
//    var id: CKRecord.ID { user_id ?? CKRecord.ID(recordName: UUID().uuidString) } // Provide a default ID if user_id is nil
//    
//    var user_id: CKRecord.ID?
//    var username: String
//    var owner_list: CKRecord.Reference?
//    var shared_list: CKRecord.Reference?
//
//    init(record: CKRecord) {
//        self.user_id = record.recordID
//        self.username = record["Name"] as? String ?? "N/A"
//        self.owner_list = record["OwnerList"] as? CKRecord.Reference
//        self.shared_list = record["SharedList"] as? CKRecord.Reference
//    }
//}
