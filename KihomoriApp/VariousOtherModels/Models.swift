//
//  Models.swift
//  KihomoriApp
//
//  Created by 本田輝 on 2024/11/01.
//

import Foundation

struct UserInfo: Codable {
    let name: String
    let iconUrl: String
}

struct TaskInfo: Codable {
    let toDo: String
    let done: Bool
}
