//
//  CKRecord+Ext.swift
//  ChefLifeMultiPlat (iOS)
//
//  Created by Mike Griffin on 6/14/21.
//

import CloudKit

extension CKRecord {
    func convertToCLRecipe() -> BCLRecipe { BCLRecipe(record: self) }
    func convertToCLTag() -> BCLTag { BCLTag(record: self) }
}
