//
//  AlertItem.swift
//  ChefLifeMultiPlat (iOS)
//
//  Created by Mike Griffin on 6/18/21.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

enum AlertContext {
    // MARK: Recipe Errors
    static let missingRecipeName = AlertItem(title: Text("Recipe Creation Error"),
                                                 message: Text("Please enter a recipe name."),
                                                 dismissButton: .default(Text("Ok")))
    static let missingRecipeIngredients = AlertItem(title: Text("Recipe Creation Error"),
                                                 message: Text("Please enter some ingredients for this recipe."),
                                                 dismissButton: .default(Text("Ok")))
    static let noRecipeForUpdate = AlertItem(title: Text("Updated Recipe Missing"),
                                             message: Text("Please select an existing recipe to update"),
                                             dismissButton: .default(Text("Ok")))
    // MARK: Tag Errors
    static let missingTagName = AlertItem(title: Text("Tag Creation Error"),
                                                 message: Text("Please enter a tag name."),
                                                 dismissButton: .default(Text("Ok")))
    // MARK: Ingredient Errors
    static let missingIngredientName = AlertItem(title: Text("Ingredient Creation Error"),
                                                 message: Text("Please enter an ingredient name."),
                                                 dismissButton: .default(Text("Ok")))
    // MARK: Measurement Errors
    static let missingMeasurementName = AlertItem(title: Text("Measurement Creation Error"),
                                                 message: Text("Please enter an measurement name."),
                                                 dismissButton: .default(Text("Ok")))
    // MARK: Cloudkit Errors
    static let noUserRecord = AlertItem(title: Text("No User Record"),
                                        message:
                                            Text("You must log in to iCloud on your phone in order "
                                                 + "to create Recipe data."),
                                        dismissButton: .default(Text("Ok")))
    // MARK: Unknown Error
    static let unknownError = AlertItem(title: Text("Error Performing Action"),
                                        message:
                                            Text("An error occurred when attempting to "
                                                  + "perform the action"),
                                        dismissButton: .default(Text("Ok")))
}
