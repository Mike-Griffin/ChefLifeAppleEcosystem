//
//  CreateIngredientLineViewModel.swift
//  ChefLifeMultiPlat (iOS)
//
//  Created by Mike Griffin on 6/18/21.
//

import Foundation
import CloudKit

class CreateIngredientLineViewModel: ObservableObject {
    @Published var quantity: String = ""
    @Published var selectedMeasurement: BCLMeasurement?
    @Published var selectedIngredient: BCLIngredient?
    @Published var alertItem: AlertItem?
    @Published var ingredientLine: BCLIngredientLine?
    func saveIngredientLine() async throws {
        guard let doubleQuantity = Double(quantity),
                let measurement = selectedMeasurement,
              let ingredient = selectedIngredient else {
                  return
              }
        guard CloudKitManager.shared.userRecord != nil else {
            alertItem = AlertContext.noUserRecord
            return
        }
        let ingredientLineRecord = createIngredientLineRecord(quantity: doubleQuantity,
                                                              measurement: measurement,
                                                              ingredient: ingredient)
        let savedRecord = try await CloudKitManager.shared.save(record: ingredientLineRecord)
        ingredientLine = savedRecord.convertToCLIngredientLine()
    }
    func createIngredientLineRecord(quantity: Double,
                                    measurement: BCLMeasurement,
                                    ingredient: BCLIngredient) -> CKRecord {
        let ingredientLineRecord = CKRecord(recordType: RecordType.ingredientLine)
        ingredientLineRecord[BCLIngredientLine.kDisplayName] = "\(quantity) \(measurement.name) \(ingredient.name)"
        ingredientLineRecord[BCLIngredientLine.kIngredient] = CKRecord.Reference(recordID: ingredient.id, action: .none)
        ingredientLineRecord[BCLIngredientLine.kMeasurement] = CKRecord.Reference(recordID:
                                                                                    measurement.id, action: .none)
        ingredientLineRecord[BCLIngredientLine.kQuantity] = quantity
        return ingredientLineRecord
    }
}
