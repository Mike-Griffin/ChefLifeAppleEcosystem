//
//  SelectMeasurementView.swift
//  ChefLifeMultiPlat (iOS)
//
//  Created by Mike Griffin on 6/18/21.
//

import SwiftUI

struct SelectMeasurementView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = SelectMeasurementViewModel()
    @Binding var selectedMeasurement: BCLMeasurement?
    var body: some View {
        if #available(iOS 15.0, *) {
            ZStack {
            VStack {
                if !searchResults.isEmpty {
                    List {
                        ForEach(searchResults) { measurement in
                            SelectableItemCell(text: measurement.name, isSelected: checkSelected(measurement))
                                .onTapGesture {
                                    selectedMeasurement = measurement
                                    presentationMode.wrappedValue.dismiss()
                                }
                        }
                    }
                } else {
                    VStack {
                        Button {
                            async {
                                try await viewModel.createMeasurement()
                                if let created = viewModel.selectedMeasurement {
                                    selectedMeasurement = created
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        } label: {
                            Text("Create new measurement \(viewModel.searchText)")
                        }
                    }
                }
            }
                if viewModel.isLoading { LoadingView() }
            }
            .searchable(text: $viewModel.searchText)
            .textFieldDisableAuto()
            .task {
                do {
                    try await viewModel.fetchMeasurements()
                    viewModel.selectedMeasurement = selectedMeasurement
                } catch {
                    print(error.localizedDescription)
                }
            }
        } else {
            Text("Have not yet implemented older version")
        }
    }
    var searchResults: [BCLMeasurement] {
        if viewModel.searchText.isEmpty {
            print(viewModel.measurements)
            return viewModel.measurements
        } else {
            let thing = viewModel.measurements.filter({ $0.name.contains(viewModel.searchText)})
            print(thing)
            return thing
        }
    }
    private func checkSelected(_ measurement: BCLMeasurement) -> Bool {
        if let stateMeasurement = viewModel.selectedMeasurement {
            return stateMeasurement.id == measurement.id
        } else {
            return false
        }
    }
}

struct SelectMeasurementView_Previews: PreviewProvider {
    @State static var measurement: BCLMeasurement? = MockData.measurement
    static var previews: some View {
        SelectMeasurementView(selectedMeasurement: $measurement)
    }
}
