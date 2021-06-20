//
//  BCLIngredientLine.swift
//  ChefLifeMultiPlat (iOS)
//
//  Created by Mike Griffin on 6/18/21.
//

import CloudKit
struct BCLIngredientLine: Identifiable {
    static let kDisplayName = "displayName"
    static let kIngredient  = "ingredient"
    static let kMeasurement = "measurement"
    static let kQuantity    = "quantity"
    let id: CKRecord.ID
    let displayName: String
    let quantity: Double
    let ingredient: CKRecord.Reference?
    let measurement: CKRecord.Reference?
    init(record: CKRecord) {
        id = record.recordID
        displayName = record[BCLIngredientLine.kDisplayName] as? String ?? "N/A"
        quantity = record[BCLIngredientLine.kQuantity] as? Double ?? 0.0
        ingredient = record[BCLIngredientLine.kIngredient] as? CKRecord.Reference ?? nil
        measurement = record[BCLIngredientLine.kMeasurement] as? CKRecord.Reference ?? nil
    }
    func convertToDeletableCKReference() -> CKRecord.Reference {
        return CKRecord.Reference(recordID: self.id, action: .deleteSelf)
    }
}
