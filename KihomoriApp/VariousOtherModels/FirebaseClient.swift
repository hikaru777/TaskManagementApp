//
//  FirebaseClient.swift
//  KihomoriApp
//
//  Created by 本田輝 on 2024/11/01.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

enum FirebaseClientFirestoreError: Error {
    case roomDataNotFound
}

enum FirebaseClient {
    
    static func settingProfile(data: UserInfo, uid: String) async throws {
        
        guard let encoded = try? Firestore.Encoder().encode(data) else { return }
        try await Firestore.firestore().collection("datas").document(uid).setData(encoded)
        
    }
    
    
    
    
}
