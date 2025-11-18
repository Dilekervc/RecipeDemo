//
//  TariflikDemoApp.swift
//  TariflikDemo
//
//  Created by Dilek Eravcı on 7.11.2025.
//

import SwiftUI
import FirebaseCore

@main
struct TariflikDemoApp: App {
    init() {
            FirebaseApp.configure()
        }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
