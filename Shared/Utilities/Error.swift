//
//  Error.swift
//  ChefLifeMultiPlat (iOS)
//
//  Created by Mike Griffin on 6/19/21.
//

import Foundation

enum ErrorContext: Error {
    case missingRecipeName
    case missingRecipeIngredients
    case missingTagName
    case missingIngredientName
    case missingMeasurementName
    case noUserRecord
    
    func mapToAlert() -> AlertItem {
        switch(self) {
        case .noUserRecord:
            return AlertContext.noUserRecord
        case .missingRecipeName:
            return AlertContext.missingRecipeName
        case .missingTagName:
            return AlertContext.missingTagName
        case .missingIngredientName:
            return AlertContext.missingIngredientName
        case .missingMeasurementName:
            return AlertContext.missingIngredientName
        case .missingRecipeIngredients:
            return AlertContext.missingRecipeIngredients
        }
    }
}
