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
    func createRecipeRecord() -> CKRecord {
        let recipeRecord = CKRecord(recordType: RecordType.recipe)
        recipeRecord[BCLRecipe.kName] = name
        recipeRecord[BCLRecipe.kIngredientLines] = ingredientLines.map({ $0.convertToDeletableCKReference() })
        recipeRecord[BCLRecipe.kTags] = tags.map({ $0.convertToCKReference() })
        return recipeRecord
    }
}
