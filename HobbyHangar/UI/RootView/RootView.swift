//
//  RootView.swift
//  HobbyHangar
//
//  Created by Nick Leach on 1/15/26.
//

import SwiftUI
import Observation

struct RootView: View {

    @Bindable private var viewModel: RootViewModel

    init(viewModel: RootViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            NavigationStack {
                LogbookView(viewModel: viewModel.makeLogbookViewModel())
            }
            .tabItem {
                Label("Logbook", systemImage: "book")
            }
            .tag(Tab.logbook)

            NavigationStack {
                HangarView(viewModel: viewModel.makeHangarViewModel())
            }
            .tabItem {
                Label("Hangar", systemImage: "airplane")
            }
            .tag(Tab.hangar)

            NavigationStack {
                BatteryTrackerView(viewModel: viewModel.makeBatteryTrackerViewModel())
            }
            .tabItem {
                Label("Batteries", systemImage: "battery.100")
            }
            .tag(Tab.batteryTracker)

            NavigationStack {
                PilotProfileView(viewModel: viewModel.makePilotProfileViewModel())
            }
            .tabItem {
                Label("Pilot Profile", systemImage: "person.crop.circle")
            }
            .tag(Tab.pilotProfile)
        }
    }
}

#Preview {
    RootView(viewModel: .init(container: .preview))
}
