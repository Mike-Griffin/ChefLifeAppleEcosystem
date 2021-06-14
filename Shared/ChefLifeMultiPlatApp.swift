//
//  ChefLifeMultiPlatApp.swift
//  Shared
//
//  Created by Mike Griffin on 6/13/21.
//

import SwiftUI

@main
struct ChefLifeMultiPlatApp: App {
    var body: some Scene {
        WindowGroup {
            #if os(iOS)
            HomeView()
            #else
            HomeView()
                .frame(minWidth: 1000, minHeight: 600)
            #endif
            
        }
    }
}
