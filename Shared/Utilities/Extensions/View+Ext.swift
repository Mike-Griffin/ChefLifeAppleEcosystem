//
//  View+Ext.swift
//  ChefLifeMultiPlat (iOS)
//
//  Created by Mike Griffin on 6/18/21.
//

import SwiftUI

extension View {
    func textFieldDisableAuto() -> some View {
        self.modifier(TextFieldDisableAuto())
    }
}
