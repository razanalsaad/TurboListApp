//
//  User.swift
//  TurboList
//
//  Created by Rahaf ALghuraibi on 27/04/1446 AH.
//

import SwiftUI
import CloudKit
class CloudkitUserViewModel : ObservableObject{
    init (){
        getiCloudStatus()
    }
    // for check about icloud signing status
    private func getiCloudStatus(){
        CKContainer.default().accountStatus{ returnedStatus, returnError in DispatchQueue.main.async{
            
        }
        }
    }
}
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
