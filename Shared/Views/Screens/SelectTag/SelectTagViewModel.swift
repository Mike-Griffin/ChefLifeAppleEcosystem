//
//  SelectTagViewModel.swift
//  ChefLifeMultiPlat (iOS)
//
//  Created by Mike Griffin on 6/19/21.
//

import Foundation
import CloudKit

class SelectTagViewModel: ObservableObject {
    @Published var tags: [BCLTag] = []
    @Published var searchText = ""
    @Published var selectedTags: [BCLTag] = []
    @Published var isLoading = false
    @Published var alertItem: AlertItem?
    func fetchTags() async throws {
        showLoadingView()
        tags = try await CloudKitManager.shared.fetchTags()
        hideLoadingView()
    }
    func createTag() async throws -> BCLTag {
        showLoadingView()
        guard !searchText.isEmpty else {
            throw ErrorContext.missingTagName
        }
        guard CloudKitManager.shared.userRecord != nil else {
            throw ErrorContext.noUserRecord
        }
        let tagRecord = createTagRecord()
        let savedRecord = try await CloudKitManager.shared.save(record: tagRecord)
        let savedTag = savedRecord.convertToCLTag()
        searchText = ""
        tags.append(savedTag)
        selectedTags.append(savedTag)
        hideLoadingView()
        return savedTag
    }
    func createTagRecord() -> CKRecord {
        let tagRecord = CKRecord(recordType: RecordType.tag)
        tagRecord[BCLTag.kName] = searchText
        return tagRecord
    }
    func handleError(_ error: Error) {
        if let context = error as? ErrorContext {
            alertItem = context.mapToAlert()
        } else {
            alertItem = AlertContext.unknownError
        }
    }
    func updateSelectedTags(_ tag: BCLTag) {
        if let selectedIndex = selectedTags.firstIndex(where: { $0.id == tag.id }) {
            selectedTags.remove(at: selectedIndex)
        } else {
            selectedTags.append(tag)
        }
    }
    func showLoadingView() { isLoading = true }
    func hideLoadingView() { isLoading = false }
}
