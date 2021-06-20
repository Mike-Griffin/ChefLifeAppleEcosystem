//
//  CLRecipe.swift
//  ChefLifeMultiPlat (iOS)
//
//  Created by Mike Griffin on 6/14/21.
//

import CloudKit
import UIKit

struct BCLRecipe {
    static let kName            = "name"
    static let kTags            = "tags"
    static let kIngredientLines = "ingredientLines"
    let ckRecordID: CKRecord.ID
    let name: String
    let tags: [CKRecord.Reference]
    let ingredientLines: [CKRecord.Reference]
    init(record: CKRecord) {
        ckRecordID = record.recordID
        name = record[BCLRecipe.kName] as? String ?? "N/A"
        tags = record[BCLRecipe.kTags] as? [CKRecord.Reference] ?? []
        ingredientLines = record[BCLRecipe.kIngredientLines] as? [CKRecord.Reference] ?? []
    }
}