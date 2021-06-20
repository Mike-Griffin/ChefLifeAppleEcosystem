//
//  HomeView.swift
//  ChefLifeMultiPlat
//
//  Created by Mike Griffin on 6/13/21.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel()
    var body: some View {
        if #available(iOS 15.0, *) {
            NavigationView {
                ZStack {
                    VStack {
                        List {
                            Text("Recipes")
                                .font(.title)
                            ForEach(viewModel.recipes) { recipe in
                                NavigationLink(destination: CreateRecipeView(recipe: recipe)) {
                                    Text(recipe.name)
                                }
                            }
                        }
                        NavigationLink(destination: CreateRecipeView(recipe: nil)) {
                            Text("Create Recipe")
                        }
                    }
                }
                if viewModel.isLoading { LoadingView() }
            }
            .task {
                async {
                    try await viewModel.fetchRecipes()
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
