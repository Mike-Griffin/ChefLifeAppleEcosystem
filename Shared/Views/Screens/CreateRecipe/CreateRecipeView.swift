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
                                                                         ingredientLines: $viewModel.ingredientLines)) {
                        Text("Update Ingredients")
                    }
                }) {
                    ForEach(viewModel.ingredientLines) { ingredient in
                        Text(ingredient.displayName)
                    }
                }
            }
            Button {
                if #available(iOS 15.0, *) {
                    async {
                        let recipe = try await viewModel.createRecipe()
                        print(recipe)
                    }
                } else {
                    print("have not implemented pre 15.0")
                }
            } label: {
                Text("Save Recipe")
            }
        }
        .onAppear {
            if let recipe = recipe {
                viewModel.populateRecipeData(recipe: recipe)
            }
        }
    }
}

struct CreateRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        CreateRecipeView(recipe: nil)
    }
}
