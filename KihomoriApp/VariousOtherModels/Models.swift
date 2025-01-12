//
//  Models.swift
//  KihomoriApp
//
//  Created by 本田輝 on 2024/11/01.
//

import Foundation
import SwiftData
//
//@Model
//final class DiaryEntry {
//    var id: UUID = UUID()
//    var content: String = ""
//    var imagesData: [Data] = []
//    var date: Date = Date.now
//    
//    @Relationship(deleteRule: .cascade, inverse: \Comment.diaryEntry)
//    var comments: [Comment]?
//    
//    init(content: String = "", imagesData: [Data] = [], date: Date = Date.now) {
//        self.content = content
//        self.imagesData = imagesData
//        self.date = date
//    }
//}

//@Model
//final class Comment {
//    var id: UUID = UUID()
//    var userId: String = ""
//    var content: String = ""
//    var date: Date = Date.now
//    
//    var diaryEntry: DiaryEntry?
//
//    init(userId: String, content: String = "", diaryEntry: DiaryEntry, date: Date = Date.now) {
//        self.userId = userId
//        self.content = content
//        self.diaryEntry = diaryEntry
//        self.date = date
//    }
//}

@Model
final class AboutTask {
    var id: UUID = UUID()
    var title: String
    var date: Date
    
    @Relationship(deleteRule: .cascade, inverse: \InsideTask.aboutTask) var infos: [InsideTask]
    
    init(title: String, date: Date, infos: [InsideTask]) {
        self.title = title
        self.date = date
        self.infos = infos
    }
}
 // 僕
@Model
final class InsideTask {
    var id: UUID = UUID()
    var done: Bool
    var aboutTask: AboutTask?
    
    @Relationship(deleteRule: .cascade, inverse: \TaskInfo.insideTask) var info: TaskInfo
    
    init(info: TaskInfo, done: Bool) {
        self.info = info
        self.done = done
    }
}

@Model
class TaskInfo {
    var id: UUID = UUID()
    var taskInfo: String
    var priority: Int
    
    var insideTask: InsideTask?
    
    init(taskInfo: String, priority: Int) {
        self.taskInfo = taskInfo
        self.priority = priority
    }
}
