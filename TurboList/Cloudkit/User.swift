//
//  User.swift
//  TurboList
//
//  Created by Rahaf ALghuraibi on 27/04/1446 AH.
//

import SwiftUI
import CloudKit
import Combine
// MARK: - User Model
struct User {
    var recordID: CKRecord.ID?
//    var userId: UUID
    var username: String
    var ownerList: [CKRecord.Reference] // Reference to lists owned by the user
    var sharedLists: [CKRecord.Reference] // Reference to shared lists

    // Convert to CKRecord
    func toRecord() -> CKRecord {
        let record = CKRecord(recordType: "User")
       // record["user_id"] = userId.uuidString as CKRecordValue
        record["username"] = username as CKRecordValue
        record["owner_id"] = ownerList as CKRecordValue
        record["shared_list"] = sharedLists as CKRecordValue
        return record
    }

    // Create from CKRecord
    init(record: CKRecord) {
        self.recordID = record.recordID
     //   self.userId = UUID(uuidString: record["user_id"] as! String) ?? UUID()
        self.username = record["username"] as! String
        self.ownerList = record["owner_id"] as? [CKRecord.Reference] ?? []
        self.sharedLists = record["shared_list"] as? [CKRecord.Reference] ?? []
    }
}
//class CloudkitUserViewModel : ObservableObject{
//    @Published var permissionStatus: Bool = false
//        @Published var isSignedInToiCloud: Bool = false
//        @Published var error: String = ""
//        @Published var userName: String = ""
//    var cancellables = Set<AnyCancellable>()
//       
//    init (){
//        getiCloudStatus()
//        requestPermission()
//        getCurrentUserName()
//    }
//    // for check about icloud signing status
//    private func getiCloudStatus() {
//           CloudKitUtility.getiCloudStatus()
//               .receive(on: DispatchQueue.main)
//               .sink { [weak self] completion in
//                   switch completion {
//                   case .finished:
//                       break
//                   case .failure(let error):
//                       self?.error = error.localizedDescription
//                   }
//               } receiveValue: { [weak self] success in
//                   self?.isSignedInToiCloud = success
//               }
//               .store(in: &cancellables)
//       }
//    func requestPermission() {
//          CloudKitUtility.requestApplicationPermission()
//              .receive(on: DispatchQueue.main)
//              .sink { _ in
//                  
//              } receiveValue: { [weak self] success in
//                  self?.permissionStatus = success
//              }
//              .store(in: &cancellables)
//      }
//    func getCurrentUserName() {
//        CloudKitUtility.discoverUserIdentity()
//            .receive(on: DispatchQueue.main)
//            .sink { _ in
//                
//            } receiveValue: { [weak self] returnedName in
//                self?.userName = returnedName
//            }
//            .store(in: &cancellables)
//    }
//    
//}

//
//struct User: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//#Preview {
//    User()
//}
