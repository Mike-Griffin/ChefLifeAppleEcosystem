//
//  SelectTagView.swift
//  ChefLifeMultiPlat (iOS)
//
//  Created by Mike Griffin on 6/19/21.
//

import SwiftUI

struct SelectTagView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = SelectTagViewModel()
    @Binding var selectedTags: [BCLTag]
    var body: some View {
        VStack {
            if #available(iOS 15.0, *) {
                ZStack {
                    VStack {
                        if !searchResults.isEmpty {
                            VStack {
                                List {
                                    ForEach(searchResults) {tag in
                                        HStack {
                                            SelectableItemCell(text: tag.name, isSelected: checkSelected(tag))
                                        }
                                        .onTapGesture {
                                            viewModel.updateSelectedTags(tag)
                                        }
                                    }
                                }
                                Spacer()
                                Button {
//                                    selectedTags = viewModel.selectedTags
                                    presentationMode.wrappedValue.dismiss()
                                } label: {
                                    Text("Save Tags")
                                }
                            }
                        } else {
                            VStack {
                                Button {
                                    async {
                                        do {
                                            _ = try await viewModel.createTag()
                                        } catch {
                                            viewModel.handleError(error)
                                            print(error.localizedDescription)
                                        }
                                    }
                                } label: {
                                    Text("Create New Tag \(viewModel.searchText)")
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
                            try await viewModel.fetchTags()
                            viewModel.selectedTags = selectedTags
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }

            } else {
                Text("Have not implemented pre ios 15 for this view")
            }
        }
        .onDisappear {
            selectedTags = viewModel.selectedTags
        }
        .alert(item: $viewModel.alertItem, content: { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        })
    }
    func checkSelected(_ tag: BCLTag) -> Bool {
        return viewModel.selectedTags.contains(where: {$0.id == tag.id})
    }
    var searchResults: [BCLTag] {
        if viewModel.searchText.isEmpty {
            return viewModel.tags
        } else {
            return viewModel.tags.filter({ $0.name.contains(viewModel.searchText)})
        }
    }

}
