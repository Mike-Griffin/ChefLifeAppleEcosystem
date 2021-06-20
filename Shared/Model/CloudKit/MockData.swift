//
//  MockData.swift
//  ChefLifeMultiPlat (iOS)
//
//  Created by Mike Griffin on 6/18/21.
//

import CloudKit

enum MockData {
    static var ingredient: BCLIngredient {
        let record = CKRecord(recordType: RecordType.ingredient)
        record[BCLIngredient.kName] = "Marinara Sauce"
        let ingredient = record.convertToCLIngredient()
        return ingredient
    }
    static var measurement: BCLMeasurement {
        let record = CKRecord(recordType: RecordType.measurement)
        record[BCLMeasurement.kName] = "Tablespoon"
        let measurement = record.convertToCLMeasurement()
        return measurement
    }
}
