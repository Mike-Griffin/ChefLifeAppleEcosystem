//
//  SelectIngredientView.swift
//  ChefLifeMultiPlat (iOS)
//
//  Created by Mike Griffin on 6/18/21.
//

import SwiftUI
import CloudKit

struct SelectIngredientView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = SelectIngredientViewModel()
    @Binding var selectedIngredient: BCLIngredient?
    var body: some View {
        if #available(iOS 15.0, *) {
            ZStack {
                VStack {
                    if !searchResults.isEmpty {
                        List {
                            ForEach(searchResults) {ingredient in
                                HStack {
                                    SelectableItemCell(text: ingredient.name, isSelected: checkSelected(ingredient))
                                }
                                .onTapGesture {
                                    selectedIngredient = ingredient
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }
                    } else {
                        VStack {
                            Button {
                                async {
                                    do {
                                        let created = try await viewModel.createIngredient()
                                        selectedIngredient = created
                                        presentationMode.wrappedValue.dismiss()
                                    } catch {
                                        viewModel.handleError(error)
                                        print(error.localizedDescription)
                                    }
                                }
                            } label: {
                                Text("Create New Ingredient \(viewModel.searchText)")
                            }
                            Spacer()
                        }
                    }
                }
                if viewModel.isLoading { LoadingView() }
            }
            .searchable(text: $viewModel.searchText)
            .textFieldDisableAuto()
            .task {
                async {
                    do {
                        try await viewModel.fetchIngredients()
                        viewModel.selectedIngredient = selectedIngredient
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            .alert(item: $viewModel.alertItem, content: { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
            })
        } else {
            Text("Have not implemented other version yet")
        }
    }
    var searchResults: [BCLIngredient] {
        print(viewModel.ingredients)
        if viewModel.searchText.isEmpty {
            return viewModel.ingredients
        } else {
            return viewModel.ingredients.filter({ $0.name.contains(viewModel.searchText)})
        }
    }
    private func checkSelected(_ ingredient: BCLIngredient) -> Bool {
        if let stateIngredient = viewModel.selectedIngredient {
            return stateIngredient.id == ingredient.id
        } else {
            return false
        }
    }
}

struct SelectIngredientView_Previews: PreviewProvider {
    @State static var ingredient: BCLIngredient? = MockData.ingredient
    static var previews: some View {
        SelectIngredientView(selectedIngredient: $ingredient)
    }
}
