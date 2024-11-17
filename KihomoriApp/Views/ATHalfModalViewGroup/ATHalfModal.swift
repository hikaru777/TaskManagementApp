//
//  AddTaskHalfModal.swift
//  KihomoriApp
//
//  Created by 本田輝 on 2024/11/10.
//

import SwiftUI

struct AddTaskHalfModal: View {
    @StateObject var viewModel: AddTaskHalfModalViewModel
    @State private var title: String = ""
    @State private var contents: [String] = [""]
    @FocusState private var focusedIndex: Int?
    @State private var keyboardHeight: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 10) {
            
            TextField("Title", text: $title)
                .font(.system(size: 25))
                .foregroundStyle(.white)
                .padding(.top, 30)
                .padding(.leading)
            
            Divider()
                .frame(maxWidth: .infinity, maxHeight: 3)
                .foregroundStyle(.white)
            
            
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(contents.indices, id: \.self) { index in
                            VStack(spacing: 10) {
                                
                                TextField("やる事", text: Binding(
                                    get: { contents[index] },
                                    set: { contents[index] = $0 }
                                ))
                                .focused($focusedIndex, equals: index)
                                .onSubmit {
                                    handleEnterPressed()
                                }
                                .padding(.leading)
                                
                                Divider()
                                    .padding(.horizontal)
                            }
                            
                            
                            if index == contents.endIndex - 1 {
                                HStack {
                                    Spacer()
                                    Button {
                                        addNewTaskAndScrollToBottom(proxy: proxy)
                                    } label: {
                                        Image(systemName: "plus.circle")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    }
                                    .padding(.trailing)
                                    .disabled(contents[index].isEmpty)
                                }
                            }
                        }
                        
                        Color.clear
                            .frame(height: 60)
                            .id("Bottom")
                    }
                }
                .onChange(of: contents.count) {
                    scrollToBottom(proxy: proxy)
                }
                .onChange(of: focusedIndex ?? -1, { oldValue, newValue in
                    print(oldValue, newValue)
                    if oldValue == -1, newValue == contents.endIndex - 1 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                            withAnimation {
                                scrollToBottom(proxy: proxy)
                            }
                        }
                    } else if newValue != contents.endIndex - 1, oldValue == -1 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                            withAnimation {
                                scrollToCell(proxy: proxy, index: newValue + 1)
                            }
                            print(oldValue, newValue, focusedIndex)
                        }
                    }
                })
            }
            .padding(.top, 7)
        }
        .padding(.top)
    }
    
    private func scrollToCell(proxy: ScrollViewProxy,index: Int) {
        proxy.scrollTo(index, anchor: .bottom)
    }
    
    private func addNewTaskAndScrollToBottom(proxy: ScrollViewProxy) {
        contents.append("")
        focusedIndex = contents.endIndex - 1
        scrollToBottom(proxy: proxy)
    }
    
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        proxy.scrollTo("Bottom", anchor: .bottom)
    }
    
    
    private func handleEnterPressed() {
        if contents.count > 1, contents.first == "" {
            contents.removeFirst()
        }
        contents = contents.enumerated().filter { index, element in
            if index == contents.endIndex - 1 && element.isEmpty {
                return false
            }
            return !element.isEmpty
        }.map { $0.element }
    }
}

