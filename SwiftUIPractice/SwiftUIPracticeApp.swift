//
//  SwiftUIPracticeApp.swift
//  SwiftUIPractice
//
//  Created by Vadim German on 20.01.2023.
//

import SwiftUI
import Firebase

@main
struct SwiftUIPracticeApp: App {
    
    init(){
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            StandsView()
        }
    }
}
