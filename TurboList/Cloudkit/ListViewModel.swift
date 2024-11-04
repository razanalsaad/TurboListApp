//
//  ListViewModel.swift
//  TurboList
//
//  Created by Rahaf ALghuraibi on 02/05/1446 AH.
//
import SwiftUI
import Combine
import CloudKit
class ListViewModel: ObservableObject {
    @Published var lists: [List] = []
    let cloudKitManager = CloudKitManager()

    // Fetch lists for a specific user
    func fetchUserLists(user: User) {
        cloudKitManager.fetchUserLists(user: user) { result in
            switch result {
            case .success(let records):
                DispatchQueue.main.async {
                    self.lists = records.map { List(record: $0) }
                }
            case .failure(let error):
                print("Failed to fetch user lists: \(error.localizedDescription)")
            }
        }
    }

//    // Add a new list
//    func addNewList(listName: String, user: User) {
//        let userRef = CKRecord.Reference(recordID: user.recordID!, action: .deleteSelf)
//        let newList = List(listId: UUID(), listName: listName, isShared: false, ownedId: userRef, createdAt: Date(), updatedAt: Date(), totalItems: 0)
//
//        cloudKitManager.addList(list: newList) { result in
//            switch result {
//            case .success(let record):
//                DispatchQueue.main.async {
//                    let addedList = List(record: record)
//                    self.lists.append(addedList)
//                }
//            case .failure(let error):
//                print("Failed to add list: \(error.localizedDescription)")
//            }
//        }
//    }
}
