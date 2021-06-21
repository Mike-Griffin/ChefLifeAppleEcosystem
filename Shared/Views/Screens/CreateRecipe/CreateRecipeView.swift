//
//  CreateRecipeView.swift
//  ChefLifeMultiPlat (iOS)
//
//  Created by Mike Griffin on 6/18/21.
//

import SwiftUI

struct CreateRecipeView: View {
    @ObservedObject var viewModel = CreateRecipeViewModel()
    var recipe: BCLRecipe?
    var body: some View {
        if #available(iOS 15.0, *) {
            VStack {
                List {
                    TextField("Name", text: $viewModel.name)
                    Section(header: HStack {
                        Text("Tags")
                        Spacer()
                        NavigationLink(destination: SelectTagView(selectedTags: $viewModel.tags)) {
                            Text("Select Tags")
                        }
                    }) {
                        // To do change this to not be just a for each
                        ForEach(viewModel.tags) { tag in
                            Text(tag.name)
                        }
                    }
                    Section(header: HStack {
                        Text("Ingredient Lines")
                        Spacer()
                        NavigationLink(destination: CreateIngredientLineView(recipeName: viewModel.name,
                                                                             ingredientLines:
                                                                                $viewModel.ingredientLines)) {
                            Text("Update Ingredients")
                        }
                    }) {
                        ForEach(viewModel.ingredientLines) { ingredient in
                            Text(ingredient.displayName)
                        }
                    }
                }
                Button {
                    async {
                        if viewModel.existingRecipe != nil {
                            do {
                                let recipe = try await viewModel.updateRecipe()
                                print(recipe)
                                
                            } catch {
                                viewModel.handleError(error)
                            }
                        } else {
                            do {
                                let recipe = try await viewModel.createRecipe()
                                print(recipe)
                            } catch {
                                viewModel.handleError(error)
                            }
                        }
                    }
                } label: {
                    if viewModel.existingRecipe != nil {
                        Text("Update Recipe")
                    } else {
                        Text("Create Recipe")
                    }
                }
            }
            .task {
                async {
                    if let recipe = recipe, viewModel.existingRecipe == nil {
                        try await viewModel.populateRecipeData(recipe: recipe)
                    }
                }
            }
            .alert(item: $viewModel.alertItem, content: { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
            })
        } else {
            Text("View not supported in this version")
        }
    }
}

struct CreateRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        CreateRecipeView(recipe: nil)
    }
}
