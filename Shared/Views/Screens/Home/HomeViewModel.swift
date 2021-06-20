//
//  HomeViewModel.swift
//  ChefLifeMultiPlat (iOS)
//
//  Created by Mike Griffin on 6/20/21.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var recipes: [BCLRecipe] = []
    @Published var isLoading = false
    func fetchRecipes() async throws {
        showLoadingView()
        recipes = try await CloudKitManager.shared.fetchRecipes()
        hideLoadingView()
    }
    func showLoadingView() { isLoading = true }
    func hideLoadingView() { isLoading = false }
}
