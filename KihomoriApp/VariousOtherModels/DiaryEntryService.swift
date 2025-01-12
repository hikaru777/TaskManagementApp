//
//  DiaryEntryService.swift
//  
//
//  Created by 本田輝 on 2024/12/09.
//


import Foundation
import SwiftData

final class TaskManagementService {
    static let shared = TaskManagementService()
    
    lazy var actor = PersistenceActor(modelContainer: Persistence.sharedModelContainer)
    
    func createTask(title: String, date: Date,tasks: [InsideTask]) async -> AboutTask {
        let tasks = AboutTask(title: title, date: date, infos: tasks)
        await actor.insert(tasks)
        return tasks
    }
    
    func saveTask(_ tasks: AboutTask) async {
        await actor.insert(tasks)
        await actor.save()
    }
    
    func getAllDiaryTasks() async -> [AboutTask] {
        let predicate = #Predicate<AboutTask> { _ in true }
        let descriptor = FetchDescriptor(predicate: predicate)
        return await actor.get(descriptor) ?? []
    }
    
    func deleteTask(id: UUID) async -> Bool {
        guard let diaryEntry = await getTaskById(id: id) else { return false }
        await actor.delete(diaryEntry)
        return true
    }
    
    private func getTaskById(id: UUID) async -> AboutTask? {
        let predicate = #Predicate<AboutTask> { $0.id == id }
        let descriptor = FetchDescriptor(predicate: predicate)
        return await actor.get(descriptor)?.first
    }
    
//    func getCommentsByUser(userId: String) async -> [Comment] {
//        let predicate = #Predicate<Comment> { $0.userId == userId }
//        let descriptor = FetchDescriptor(predicate: predicate)
//        return await actor.get(descriptor) ?? []
//    }
}
