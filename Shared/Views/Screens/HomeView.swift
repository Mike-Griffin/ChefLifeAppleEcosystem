//
//  HomeView.swift
//  ChefLifeMultiPlat
//
//  Created by Mike Griffin on 6/13/21.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        if #available(iOS 15.0, *) {
            Text("Welcome Home there ")
                .task {
                    async {
                        let recipes = try await CloudKitManager.shared.fetchRecipes()
                        print(recipes)
                        for recipe in recipes {
                            for tagRecord in recipe.tags {
                                let tag = try await CloudKitManager.shared.fetchTag(with: tagRecord.recordID)
                                print(tag)
                            }
                        }
                    }
                }
        } else {
            // Fallback on earlier versions
            Text("Not ios 15")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
