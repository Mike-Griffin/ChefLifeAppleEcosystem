//
//  SelectableItem.swift
//  ChefLifeMultiPlat (iOS)
//
//  Created by Mike Griffin on 6/18/21.
//

import CloudKit

struct SelectableItem: Identifiable {
    let id: CKRecord.ID
    let text: String
    var isSelected: Bool
}
