//
//  SelectableItemList.swift
//  ChefLifeMultiPlat (iOS)
//
//  Created by Mike Griffin on 6/18/21.
//

import SwiftUI
import CloudKit

struct SelectableItemList: View {
    @Binding var selectableItems: [SelectableItem]
    var didSelectItem: (CKRecord.ID) -> Void
    var body: some View {
        ForEach(selectableItems) { item in
            HStack {
                Text(item.text)
                if item.isSelected {
                    Image(systemName: "checkmark.circle.fill")
                }
            }
            .onTapGesture {
                didSelectItem(item.id)
            }
        }
//        ForEach(0..<5) { _ in
//            Text("hi")
//        }
    }
}

struct SelectableItemList_Previews: PreviewProvider {
    static func didSelect(id: CKRecord.ID) {
        print("selected")
    }
    @State static var items: [SelectableItem] = []
    static var previews: some View {
        SelectableItemList(selectableItems: $items, didSelectItem: didSelect)
    }
}
