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
        let recipes = records.map({ $0.convertToCLRecipe() })
        return recipes
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
    // This needs some work to understand
//    func batchFetchTags(with ids: [CKRecord.ID]) async throws -> [BCLTag] {
//        if #available(iOS 15.0, *) {
//            let records = try await CKContainer.default().publicCloudDatabase.records(for: ids)
//            let tags =  records.map({ $0.convertToCLTag() })
//            return tags
//        } else {
//            print("sorry can't do this one")
//            return []
//        }
//    }
}
