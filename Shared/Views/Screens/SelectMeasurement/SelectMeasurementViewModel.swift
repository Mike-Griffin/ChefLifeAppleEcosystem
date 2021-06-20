//
//  SelectMeasurementViewModel.swift
//  ChefLifeMultiPlat (iOS)
//
//  Created by Mike Griffin on 6/18/21.
//

import Foundation
import CloudKit

class SelectMeasurementViewModel: ObservableObject {
    @Published var measurements: [BCLMeasurement] = []
    @Published var selectedMeasurement: BCLMeasurement?
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var alertItem: AlertItem?
    func fetchMeasurements() async throws {
        showLoadingView()
        measurements = try await CloudKitManager.shared.fetchMeasurements()
        hideLoadingView()
    }
    func createMeasurement() async throws {
        showLoadingView()
        guard !searchText.isEmpty else {
            alertItem = AlertContext.missingMeasurementName
            return
        }
        guard CloudKitManager.shared.userRecord != nil else {
            alertItem = AlertContext.noUserRecord
            return
        }
        let measurementRecord = createMeasurementRecord()
        let savedRecord = try await CloudKitManager.shared.save(record: measurementRecord)
        selectedMeasurement = savedRecord.convertToCLMeasurement()
        hideLoadingView()
    }
    private func createMeasurementRecord() -> CKRecord {
        let measurementRecord = CKRecord(recordType: RecordType.measurement)
        measurementRecord[BCLMeasurement.kName] = searchText
        return measurementRecord
    }
    func showLoadingView() { isLoading = true }
    func hideLoadingView() { isLoading = false }
}
