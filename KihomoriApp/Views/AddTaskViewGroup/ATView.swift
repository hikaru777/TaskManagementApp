//
//  AddTaskView.swift
//  KihomoriApp
//
//  Created by 本田輝 on 2024/10/31.
//

import Data
import SwiftUI

struct AddTaskView: View {
    @State var showAddTaskView: Bool = false
    var body: some View {
        
        ZStack {
            List() {
                Text("aaa")
                Text("aaa")
                Text("aaa")
            }
            .listRowSpacing(10)
            VStack {
                Spacer()
                Button {
                    
                    showAddTaskView.toggle()
                    
                } label: {
                    Text("Add Task")
                        .foregroundStyle(.white)
                        .font(.system(size: 20))
                        .padding(15)
                        .background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .padding(.bottom, 20)
                }

            }
            
            
            
        }
        .sheet(isPresented: $showAddTaskView) {
            AddTaskHalfModal(viewModel: .init())
                .presentationDetents([.fraction(0.8)])
        }
    }
}

#Preview {
    AddTaskView()
}
