//
//  SelectableItemCell.swift
//  ChefLifeMultiPlat (iOS)
//
//  Created by Mike Griffin on 6/18/21.
//

import SwiftUI

struct SelectableItemCell: View {
    var text: String
    var isSelected: Bool
    var body: some View {
        HStack {
            Text(text)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
            }
        }
    }
}
