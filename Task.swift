//
//  Task.swift
//  
//
//  Created by 本田輝 on 2024/11/24.
//


import SwiftData

@Model
class Task {
    var title: String
    var contents: [String]
    var priorities: [Int]

    init(title: String, contents: [String], priorities: [Int]) {
        self.title = title
        self.contents = contents
        self.priorities = priorities
    }
}