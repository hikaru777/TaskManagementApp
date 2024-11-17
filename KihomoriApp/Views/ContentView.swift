//
//  ContentView.swift
//  KihomoriApp
//
//  Created by 本田輝 on 2024/10/13.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        
        Text("huh")
        
//        Group {
//            if let location = locationManager.location {
//                MapView(centerCoordinate: .constant(location))
//                    .edgesIgnoringSafeArea(.all)
//            } else {
//                Text("現在地を取得中...")
//            }
//        }
    }
}


#Preview {
    ContentView()
}
