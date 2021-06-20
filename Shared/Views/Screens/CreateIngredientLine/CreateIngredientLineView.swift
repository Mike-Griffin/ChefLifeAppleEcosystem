//
//  CreateIngredientLineView.swift
//  ChefLifeMultiPlat (iOS)
//
//  Created by Mike Griffin on 6/18/21.
//

import SwiftUI

struct CreateIngredientLineView: View {
    // @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = CreateIngredientLineViewModel()
    var recipeName: String?
    @Binding var ingredientLines: [BCLIngredientLine]
    var body: some View {
        List {
            TextField("Quantity", text: $viewModel.quantity)
                .keyboardType(.numbersAndPunctuation)
            NavigationLink(destination: SelectMeasurementView(selectedMeasurement: $viewModel.selectedMeasurement)) {
                IngredientLineItemView(name: viewModel.selectedMeasurement?.name, text: "Measurement")
            }
            NavigationLink(destination: SelectIngredientView(selectedIngredient: $viewModel.selectedIngredient)) {
                IngredientLineItemView(name: viewModel.selectedIngredient?.name, text: "Ingredient")
            }
            Button {
                if #available(iOS 15.0, *) {
                    async {
                        try await viewModel.saveIngredientLine()
                        if let created = viewModel.ingredientLine {
                            ingredientLines.append(created)
                            // I need to figure out why this is causing issues on the next view
                            // presentationMode.wrappedValue.dismiss()
                        }
                    }
                } else {
                    // Fallback on earlier versions
                    print("have not impleted should turn this into an alert")
                }
            } label: {
                Text("Update Ingredient")
            }

        }
        .navigationTitle(recipeName != nil
                         ? "Update Ingredients for \(recipeName!)"
                         : "Update Ingredients for New Recipe")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct IngredientLineItemView: View {
    var name: String?
    var text: String
    var body: some View {
        VStack {
            if #available(iOS 15.0, *) {
                Text(text)
                    .badge(name != nil
                           ? name!
                           : "Select \(text)")
            } else {
                HStack {
                    Text(text)
                    Spacer()
                    if let name = name {
                        Text(name)
                    } else {
                        Text("Select \(text)")
                    }
                }
            }
        }
    }
}
