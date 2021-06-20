//
//  CLRecipe.swift
//  ChefLifeMultiPlat (iOS)
//
//  Created by Mike Griffin on 6/14/21.
//

import CloudKit
import UIKit

struct BCLRecipe: Identifiable {
    static let kName            = "name"
    static let kTags            = "tags"
    static let kIngredientLines = "ingredientLines"
    let id: CKRecord.ID
    let name: String
    let tags: [CKRecord.Reference]
    let ingredientLines: [CKRecord.Reference]
    init(record: CKRecord) {
        id = record.recordID
        name = record[BCLRecipe.kName] as? String ?? "N/A"
        tags = record[BCLRecipe.kTags] as? [CKRecord.Reference] ?? []
        ingredientLines = record[BCLRecipe.kIngredientLines] as? [CKRecord.Reference] ?? []
    }
}
