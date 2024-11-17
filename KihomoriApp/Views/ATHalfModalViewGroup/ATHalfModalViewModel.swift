//
//  AddTaskHalfModalViewModel.swift
//  KihomoriApp
//
//  Created by 本田輝 on 2024/11/18.
//

import SwiftUI

class AddTaskHalfModalViewModel: ObservableObject {
    
    func handleEnterPressed(contents: inout [String]) {
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
