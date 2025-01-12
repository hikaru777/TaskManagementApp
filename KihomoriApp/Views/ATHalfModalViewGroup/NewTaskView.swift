//
//  NewTaskView.swift
//  KihomoriApp
//
//  Created by 本田輝 on 2025/01/11.
//

//    @Binding var selectedTask: TaskType?

//    var onSave: (TaskInfo) -> Void

import SwiftUI

struct NewTaskView: View {
    @Binding var text: String
    @State var show = false
    @State var show2 = false
    @Namespace var animation
    @FocusState var isTyping
    
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    
    var body: some View {
        
        ZStack(alignment: show ? .topLeading : .center) {
            RoundedRectangle(cornerRadius: show ? 24 : 40)
                .foregroundStyle(Color(.systemGray6))
                .frame(maxHeight: show ? 250 : 50)
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    deployToggle()
                }
                .disabled(show)
            
            ZStack(alignment: show ? .topLeading : .center) {
                
                Text("New Task")
                    .bold()
                    .opacity(show ? 0 : 1)
                
                VStack(spacing: 25) {
                    
                    HStack(spacing: 10) {
                        
                        ZStack(alignment: .bottom) {
                            
                            TextField("Task Name", text: $text)
                                .bold()
                                .font(.system(size: 25))
                                .disabled(!show)
                                .focused($isTyping)
                                .padding(.leading, show ? 3 : 50)
                            
                            RoundedRectangle(cornerRadius: 30)
                                .frame(width: .infinity, height: 2)
                                .foregroundStyle(isTyping || !text.isEmpty ? .white : .gray)
                                .animation(.easeInOut(duration: 0.2), value: text.isEmpty)
                                .animation(.easeInOut(duration: 0.2), value: isTyping)
                        }
                        
                        Button {
                            closeToggle()
                        } label: {
                            Image(systemName: "x.circle.fill")
                                .resizable()
                                .frame(width: 21, height: 21)
                                .foregroundStyle(.gray)
                        }
                    }
                    .opacity(show ? 1 : 0)
                    
                    if show2 {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("・作業期間")
                                .bold()
                                .font(.system(size: 20))
                                .frame(maxWidth: .infinity, alignment: .leading) // 中央に配置
                                .padding(.leading)
                            
                            // Start Date, End Date セクション
                            HStack(alignment: .center, spacing: 40) {
                                VStack(alignment: .leading) {
                                    Text("Start Date")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .frame(maxWidth: .infinity, alignment: .center) // 中央揃え
                                    DatePicker("", selection: $startDate, displayedComponents: .date)
                                        .datePickerStyle(CompactDatePickerStyle())
                                        .labelsHidden()
                                }
                                
                                Text("〜")
                                    .bold()
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                
                                VStack(alignment: .leading) {
                                    Text("End Date")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .frame(maxWidth: .infinity, alignment: .center) // 中央揃え
                                    DatePicker("", selection: $endDate, displayedComponents: .date)
                                        .datePickerStyle(CompactDatePickerStyle())
                                        .labelsHidden()
                                }
                            }
                            .frame(maxWidth: .infinity) // セクションを中央揃え
                            .padding(.horizontal, 20)
                            
                            // 右下のボタン
                            HStack {
                                Spacer()
                                Button(action: {
                                    print("Next button tapped")
                                    // 次のアクションをここに記述
                                }) {
                                    Image(systemName: "arrow.right")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(.black)
                                        .padding()
                                        .background {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(.white)
                                                .shadow(radius: 3)
                                                .frame(width: 60, height: 40)
                                        }
                                }
                                .padding(.trailing, 20)
                                .padding(.top, 15)
                            }
                        }
                    }
                }
            }
            .padding(15)
        }
        .padding(.horizontal, show ? 0 : 100)
        .onTapGesture {
            withAnimation {
                isTyping = false
            }
        }
    }
    
    func deployToggle() {
        withAnimation {
            show.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation{
                    show2.toggle()
                }
            }
        }
    }
    
    func closeToggle() {
        withAnimation {
            show2.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    show.toggle()
                }
            }
        }
    }
}


#Preview(body: {
    @Previewable @State var text = ""
    NewTaskView(text: $text)
})
