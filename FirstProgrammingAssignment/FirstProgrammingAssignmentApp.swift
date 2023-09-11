//
//  FirstProgrammingAssignmentApp.swift
//  FirstProgrammingAssignment
//
//  Created by Nilesh Manivannan on 9/9/23.
//

import SwiftUI
import Firebase

@main
struct FirstProgrammingAssignmentApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
