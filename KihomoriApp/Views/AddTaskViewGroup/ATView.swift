//
//  AddTaskView.swift
//  KihomoriApp
//
//  Created by 本田輝 on 2024/10/31.
//

import SwiftUI

struct AddTaskView: View {
    @State private var showAddTaskView: Bool = false
    @State private var tasks: [AboutTask] = []
    
    let columns = [
        GridItem(.flexible(), spacing: 5),
        GridItem(.flexible(), spacing: 5)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                GeometryReader { geometry in
                    
                    let width = (geometry.size.width - 30) / 2
                    
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(tasks, id: \.self) { task in
                    
                                TaskCard(task: task.title, doneRate: task.infos)
                                    .frame(
                                        width: width,
                                        height: width + 50
                                    )
                                    .onTapGesture {
                                        for i in task.infos {
                                            print("タスク詳細:")
                                        }
                                    }
                            }
                        }
                        .padding(10)
                    }
                }
                
                VStack {
                    Spacer()
                    Button {
                        showAddTaskView.toggle()
                    } label: {
                        Text("Add Task")
                            .foregroundStyle(.black)
                            .font(.system(size: 20))
                            .padding(15)
                            .background(Color(.white).opacity(0.7))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.bottom, 20)
                    }
                }
            }
            .background(WavyGradientBackground())
//            .sheet(isPresented: $showAddTaskView) {
//                AddTaskHalfModal(viewModel: .init()) { taskInfo in
//                    tasks.append(contentsOf: taskInfo)
//                }
//                .presentationDetents([.fraction(0.8)])
//            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Tasks")
                }
            }
        }
    }
}

// TaskCard Component
struct TaskCard: View {
    let task: String
    let doneRate: [InsideTask]
    
    var calculatedOpacity: Double {
        guard !doneRate.isEmpty else { return 1.0 } // 空の場合は完全不透明
        
        let trueCount = doneRate.filter { $0.done }.count
        let trueRatio = Double(trueCount) / Double(doneRate.count)
        
        // 全部trueなら0、全部falseなら1、割合に応じて線形補間
        return 1.0 - trueRatio
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.ultraThinMaterial.opacity(0.8))
                .shadow(radius: 2)
                .opacity(calculatedOpacity) // Opacityを設定
            VStack {
                Text(task)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
    }
}

#Preview {
    AddTaskView()
}
