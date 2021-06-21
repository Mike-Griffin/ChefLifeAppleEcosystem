//
//  CloudKitManager.swift
//  ChefLifeMultiPlat (iOS)
//
//  Created by Mike Griffin on 6/14/21.
//

import CloudKit

final class CloudKitManager {
    static let shared = CloudKitManager()
    private init() {}
    var userRecord: CKRecord?
    func getUserRecord() {
        CKContainer.default().fetchUserRecordID { recordID, error in
            guard let recordID = recordID, error == nil else {
                print(error!.localizedDescription)
                return
            }

            CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { userRecord, error in
                guard let userRecord = userRecord, error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                self.userRecord = userRecord
            }
        }
   //     let recordID = try await CKContainer.default().fetchUserRecordID
    }
    func fetchRecipes() async throws -> [BCLRecipe] {
        let query = CKQuery(recordType: RecordType.recipe, predicate: NSPredicate(value: true))
        let records = try await CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil)
        return records.map({ $0.convertToCLRecipe() })
    }
    func fetchTag(with id: CKRecord.ID) async throws -> BCLTag {
        let record = try await CKContainer.default().publicCloudDatabase.record(for: id)
        return record.convertToCLTag()
    }
    func fetchTags() async throws -> [BCLTag] {
        let query = CKQuery(recordType: RecordType.tag, predicate: NSPredicate(value: true))
        let records = try await CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil)
        return records.map({ $0.convertToCLTag() })
    }
    func batchFetchTags(with ids: [CKRecord.ID]) async throws -> [BCLTag] {
        var tags: [BCLTag] = []
        if #available(iOS 15.0, *) {
            let records = try await CKContainer.default().publicCloudDatabase.records(for: ids, desiredKeys: nil)
            for record in records {
                switch record.value {
                case .success(let tagRecord):
                    tags.append(tagRecord.convertToCLTag())
                case .failure(_):
                    print("Error fetching a tag in batch fetch")
                }
            }
        } else {
            print("Batch fetch tags has not converted")
        }
        return tags
    }
    func batchFetchIngredientLines(with ids: [CKRecord.ID]) async throws -> [BCLIngredientLine] {
        var ingredientLines: [BCLIngredientLine] = []
        if #available(iOS 15.0, *) {
            let records = try await CKContainer.default().publicCloudDatabase.records(for: ids, desiredKeys: nil)
            for record in records {
                switch record.value {
                case .success(let ingredientLineRecord):
                    ingredientLines.append(ingredientLineRecord.convertToCLIngredientLine())
                case .failure(_):
                    print("Error fetching an ingredient line in batch fetch")
                }
            }
        } else {
            print("Batch fetch ingredient lines has not converted")
        }
        return ingredientLines
    }
    func fetchMeasurements() async throws -> [BCLMeasurement] {
        let query = CKQuery(recordType: RecordType.measurement, predicate: NSPredicate(value: true))
        let records = try await CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil)
        return records.map({ $0.convertToCLMeasurement() })
    }
    func fetchIngredients() async throws -> [BCLIngredient] {
        let query = CKQuery(recordType: RecordType.ingredient, predicate: NSPredicate(value: true))
        let records = try await CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil)
        let ingredients = records.map({ $0.convertToCLIngredient() })
        return ingredients
    }
    func save(record: CKRecord) async throws -> CKRecord {
        let record = try await CKContainer.default().publicCloudDatabase.save(record)
        return record
    }
    func fetchRecord(id: CKRecord.ID) async throws -> CKRecord {
        return try await CKContainer.default().publicCloudDatabase.record(for: id)
    }
}
