//
//  CreateRecipeViewModel.swift
//  ChefLifeMultiPlat (iOS)
//
//  Created by Mike Griffin on 6/18/21.
//

import CloudKit

class CreateRecipeViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var ingredientLines: [BCLIngredientLine] = []
    @Published var tags: [BCLTag] = []
    @Published var existingRecipe: BCLRecipe?
    @Published var isLoading = false
    @Published var alertItem: AlertItem?
    func createRecipe() async throws -> BCLRecipe {
        guard !name.isEmpty else {
            throw ErrorContext.missingRecipeName
        }
        guard !ingredientLines.isEmpty else {
            throw ErrorContext.missingRecipeIngredients
        }
        guard CloudKitManager.shared.userRecord != nil else {
            throw ErrorContext.noUserRecord
        }
        let recipeRecord = createRecipeRecord()
        let savedRecord = try await CloudKitManager.shared.save(record: recipeRecord)
        return savedRecord.convertToCLRecipe()
    }
    func updateRecipe() async throws -> BCLRecipe {
        print("up in update")
        guard !name.isEmpty else {
            throw ErrorContext.missingRecipeName
        }
        guard !ingredientLines.isEmpty else {
            throw ErrorContext.missingRecipeIngredients
        }
        guard CloudKitManager.shared.userRecord != nil else {
            throw ErrorContext.noUserRecord
        }
//        guard let recipeRecord = try await CloudKitManager.shared.fetchRecord(id: <#T##CKRecord.ID#>) else {
//            throw ErrorContext.noRecipeForUpdate
//        }
        guard let recipe = existingRecipe else {
            throw ErrorContext.noRecipeForUpdate
        }
        showLoadingView()

        let recipeRecord = try await CloudKitManager.shared.fetchRecord(id: recipe.id)
        recipeRecord[BCLRecipe.kName] = name
        recipeRecord[BCLRecipe.kIngredientLines] = ingredientLines.map({ $0.convertToDeletableCKReference() })
        recipeRecord[BCLRecipe.kTags] = tags.map({ $0.convertToCKReference() })
        let savedRecord = try await CloudKitManager.shared.save(record: recipeRecord)
        hideLoadingView()
        return savedRecord.convertToCLRecipe()
    }
    func createRecipeRecord() -> CKRecord {
        let recipeRecord = CKRecord(recordType: RecordType.recipe)
        recipeRecord[BCLRecipe.kName] = name
        recipeRecord[BCLRecipe.kIngredientLines] = ingredientLines.map({ $0.convertToDeletableCKReference() })
        recipeRecord[BCLRecipe.kTags] = tags.map({ $0.convertToCKReference() })
        return recipeRecord
    }
    func populateRecipeData(recipe: BCLRecipe) async throws {
        print("populate is called")
        print(recipe)
        name = recipe.name
        let tagsIds = recipe.tags.map({$0.recordID})
        tags = try await CloudKitManager.shared.batchFetchTags(with: tagsIds)
        let ingredientIds = recipe.ingredientLines.map({$0.recordID})
        ingredientLines = try await CloudKitManager.shared.batchFetchIngredientLines(with: ingredientIds)
        existingRecipe = recipe
    }
    func handleError(_ error: Error) {
        print(error.localizedDescription)
        if let context = error as? ErrorContext {
            alertItem = context.mapToAlert()
        } else {
            alertItem = AlertContext.unknownError
        }
    }
    func showLoadingView() { isLoading = true }
    func hideLoadingView() { isLoading = false }
}
