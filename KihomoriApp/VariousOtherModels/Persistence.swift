//
//  Persistence.swift
//  
//
//  Created by 本田輝 on 2024/12/09.
//


import Foundation
import SwiftData

class Persistence {
    static var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            AboutTask.self,
            InsideTask.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Failed to create sharedModelContainer: \(error)")
        }
    }()
}
