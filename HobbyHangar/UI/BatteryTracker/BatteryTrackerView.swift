//
//  BatteryTrackerView.swift
//  HobbyHangar
//
//  Created by Nick Leach on 1/21/26.
//

import SwiftUI
import FactoryKit

struct BatteryTrackerView: View {
    @Bindable private var viewModel: BatteryTrackerViewModel

    init(viewModel: BatteryTrackerViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Text("Battery Tracker")
            .font(.title)
            .navigationTitle("Battery Tracker")
    }
}

#Preview {
    NavigationStack {
        BatteryTrackerView(viewModel: .init())
    }.task {
        Container.shared.setupPreviewMocks()
    }
}
