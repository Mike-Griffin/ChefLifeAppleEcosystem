//
//  BCLIngredient.swift
//  ChefLifeMultiPlat (iOS)
//
//  Created by Mike Griffin on 6/18/21.
//

import CloudKit
struct BCLIngredient: Identifiable {
    static let kName = "name"
    let id: CKRecord.ID
    let name: String
    init(record: CKRecord) {
        id = record.recordID
        name = record[BCLIngredient.kName] as? String ?? "N/A"
    }
}
