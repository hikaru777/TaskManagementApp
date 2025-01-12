//
//  PersistenceActor.swift
//  
//
//  Created by 本田輝 on 2024/12/09.
//


import Foundation
import SwiftData

actor PersistenceActor: ModelActor {
    let modelContainer: ModelContainer
    let modelExecutor: any ModelExecutor
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        let context = ModelContext(modelContainer)
        modelExecutor = DefaultSerialModelExecutor(modelContext: context)
    }
    
    func save() {
        do {
            try modelContext.save()
        } catch {
            print("Error saving data")
        }
    }
    
    func insert<T: PersistentModel>(_ value: T) {
        do {
            modelContext.insert(value)
            try modelContext.save()
        } catch {
            print("Error inserting data")
        }
    }
    
    func delete<T: PersistentModel>(_ value: T) {
        do {
            modelContext.delete(value)
            try modelContext.save()
        } catch {
            print("Error deleting data")
        }
    }
    
    func get<T: PersistentModel>(_ descriptor: FetchDescriptor<T>) -> [T]? {
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching data")
            return nil
        }
    }
}
