//
//  SelectIngredientViewModel.swift
//  ChefLifeMultiPlat (iOS)
//
//  Created by Mike Griffin on 6/18/21.
//

import Foundation
import CloudKit

class SelectIngredientViewModel: ObservableObject {
    @Published var ingredients: [BCLIngredient]     = []
    @Published var searchText                       = ""
    @Published var isLoading                        = false
    @Published var selectedIngredient: BCLIngredient?
    @Published var alertItem: AlertItem?
    func fetchIngredients() async throws {
        showLoadingView()
        ingredients = try await CloudKitManager.shared.fetchIngredients()
        hideLoadingView()
    }
    func createIngredient() async throws -> BCLIngredient {
        showLoadingView()
        guard !searchText.isEmpty else {
            throw ErrorContext.missingIngredientName
        }
        guard CloudKitManager.shared.userRecord != nil else {
            alertItem = AlertContext.noUserRecord
            throw ErrorContext.noUserRecord
        }
        let ingredientRecord = createIngredientRecord()
        let savedRecord = try await CloudKitManager.shared.save(record: ingredientRecord)
        selectedIngredient = savedRecord.convertToCLIngredient()
        hideLoadingView()
        return selectedIngredient!
    }
    func createIngredientRecord() -> CKRecord {
        let ingredientRecord = CKRecord(recordType: RecordType.ingredient)
        ingredientRecord[BCLIngredient.kName] = searchText
        return ingredientRecord
    }
    func handleError(_ error: Error) {
        if let context = error as? ErrorContext {
            alertItem = context.mapToAlert()
        } else {
            alertItem = AlertContext.unknownError
        }
    }
    func showLoadingView() { isLoading = true }
    func hideLoadingView() { isLoading = false }
}
