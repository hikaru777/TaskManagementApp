//
//  AddTaskHalfModal.swift
//  KihomoriApp
//
//  Created by 本田輝 on 2024/11/10.
//

import SwiftUI

struct AddTaskHalfModal: View {
    @StateObject var viewModel: AddTaskHalfModalViewModel
    @State var insideTask: [InsideTask] = []
    @State private var title: String = ""
    @State private var contents: [(todo:String, priority:Int)] = [("",1)]
    @FocusState private var focusedIndex: Int?
    @Environment(\.dismiss) private var dismiss
    @State var tapped: Bool = false
    
    var onAddTask: (([AboutTask]) -> Void)? // タスク追加時の外部通知クロージャ
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Button {
                        Task {
                            for i in contents {
                                insideTask.append(InsideTask(info: TaskInfo(taskInfo: i.todo, priority: i.priority), done: false))
                            }
                            let taskData = await TaskManagementService.shared.createTask(title: title, date: Date.now, tasks: insideTask)
                            onAddTask?([taskData])
                        }
                        dismiss()
                    } label: {
                        Text("完了")
                    }
                    .disabled(title.isEmpty || insideTask.isEmpty)
                }
                Spacer()
            }
            .padding(.trailing)
            
            VStack(spacing: 10) {
                TextField("Title", text: $title)
                    .font(.system(size: 25))
                    .foregroundStyle(.white)
                    .padding(.top, 30)
                    .padding(.leading)
                    .onSubmit {
                        hideKeyboard()
                    }
                
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 3)
                    .foregroundStyle(.white)
                
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(contents.indices, id: \.self) { index in
                                
                                taskRow(for: index)
                                
                                if index == contents.endIndex - 1 {
                                    HStack {
                                        Spacer()
                                        addTaskButton(proxy: proxy, index: index) // 切り出した関数を呼び出し
                                    }
                                }
                            }
                            
                            Color.clear
                                .frame(height: 60)
                                .id("Bottom")
                        }
                    }
                    .onTapGesture {
                        focusedIndex = nil
                    }
                    .onChange(of: contents.count) {
                        scrollToBottom(proxy: proxy)
                    }
                    .onChange(of: focusedIndex) {
                        scrollToBottom(proxy: proxy)
                    }
                }
                .padding(.top, 7)
            }
        }
//        .background(WavyGradientBackground())
        .padding(.top)
        .background(.ultraThinMaterial.opacity(0.8))
    }
    
    
    
    private func handleEnterPressed() {
        guard let index = focusedIndex else {
            hideKeyboard()
            return
        }
        
        // 最初の要素が空の場合
        if index == 0 {
            hideKeyboard()
            return
        }
        
        // 現在のインデックスが空の場合、その要素を削除
        if contents[index].todo.isEmpty {
            contents.remove(at: index)
            focusedIndex = nil
            hideKeyboard()
            return
        }
        
        // contentsの最初の要素が空で、複数要素がある場合は削除
        if contents.count > 1, contents.first?.todo.isEmpty ?? false {
            contents.removeFirst()
        }
        
        // contentsの中で空の要素を削除
        contents = contents.enumerated().filter { index, element in
            if index == contents.endIndex - 1 && element.todo.isEmpty {
                return false // 最後の空要素を削除
            }
            return !element.todo.isEmpty // 空でない要素を保持
        }.map { $0.element } // フィルタリング後、`element`を抽出
    }
    
    private func addNewTaskAndScrollToBottom(proxy: ScrollViewProxy) {
        contents.append(("", 1))
        focusedIndex = contents.endIndex - 1
        scrollToBottom(proxy: proxy)
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        proxy.scrollTo("Bottom", anchor: .bottom)
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func getTodoBinding(at index: Int) -> Binding<String> {
        Binding(
            get: { contents[index].todo },
            set: { contents[index].todo = $0 }
        )
    }
    
    @ViewBuilder
    private func taskRow(for index: Int) -> some View {
        VStack {
            HStack(alignment: .top, spacing: 10) {
                TextField("やる事", text: getTodoBinding(at: index), axis: .vertical)
                    .focused($focusedIndex, equals: index)
                    .onSubmit {
                        handleEnterPressed()
                        hideKeyboard()
                    }
                    .padding(.leading)
                    .frame(minHeight: 40, maxHeight: 150)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(5)
                
                HStack(spacing: 5) {
                    priorityPicker(for: index, tapped: tapped)
                }
            }
            
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 1)
                .foregroundStyle(.white)
                .padding(.trailing, 80)
            
        }
    }
    
    @ViewBuilder
    private func priorityPicker(for index: Int, tapped: Bool) -> some View {
        ZStack {
            // 星のグループ
            ZStack {
                ForEach(1...3, id: \.self) { priority in
                    Image(systemName: contents[index].priority >= priority ? "star.fill" : "star")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.yellow)
                        .onTapGesture {
                            contents[index].priority = priority
                        }
                    // 星の位置をpaddingで調整
                        .padding(.bottom, paddingValue(for: priority, axis: .bottom, tapped: tapped))
                        .padding(.leading, paddingValue(for: priority, axis: .leading, tapped: tapped))
                        .padding(.trailing, paddingValue(for: priority, axis: .trailing, tapped: tapped))
                }
            }
            
            // 青い円ボタン（中央固定）
            Button {
                withAnimation {
                    self.tapped.toggle()
                }
            } label: {
                Circle()
                    .frame(width: 42, height: 42)
                    .foregroundColor(.blue)
            }
        }
    }
    
    @ViewBuilder
    private func addTaskButton(proxy: ScrollViewProxy, index: Int) -> some View {
        Button {
            addNewTaskAndScrollToBottom(proxy: proxy)
        } label: {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 15, height: 15)
                .foregroundColor(contents[index].todo.isEmpty ? .black : .white)
                .padding(5)
                .background(Circle().foregroundColor(contents[index].todo.isEmpty ? .gray : .blue).frame(width: 30, height: 30))
        }
        .padding(.trailing)
        .offset(x: contents[index].todo.isEmpty ? 30 : 0)
        .opacity(contents[index].todo.isEmpty ? 0 : 1)
        .animation(.easeInOut(duration: 0.3), value: contents[index].todo.isEmpty)
        .disabled(contents[index].todo.isEmpty)
    }
    
    private enum Axis {
        case leading, trailing, bottom
    }
    
    private func paddingValue(for priority: Int, axis: Axis, tapped: Bool) -> CGFloat {
        guard tapped else { return 0 } // 初期状態ではすべて0
        
        let basePadding: CGFloat = 50 // 基準のpadding値
        
        switch (priority, axis) {
        case (1, .trailing): return basePadding // 左上の星
        case (1, .bottom): return basePadding
        case (2, .bottom): return basePadding * 1.5 // 真ん中の星が上に出る
        case (3, .leading): return basePadding // 右上の星
        case (3, .bottom): return basePadding
        default: return 0
        }
    }
    
}

#Preview {
    AddTaskHalfModal(viewModel: .init(), onAddTask: { taskInfo in
        for i in taskInfo {
            print("新しいタスクが追加されました: \(i.id)")
            print("内容: \(i.title)")
        }
    })
}
