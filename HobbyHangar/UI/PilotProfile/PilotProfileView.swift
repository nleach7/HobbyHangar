//
//  PilotProfileView.swift
//  HobbyHangar
//
//  Created by Nick Leach on 1/21/26.
//

import SwiftUI

struct PilotProfileView: View {
    @Bindable private var viewModel: PilotProfileViewModel

    init(viewModel: PilotProfileViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            if let welcomeMessage = viewModel.welcomeMessage {
                Text(welcomeMessage)
                    .font(.title)
            } else {
                ProgressView()
                    .padding()
            }
        }
        .navigationTitle("Pilot Profile")
        .onAppear {
            viewModel.onAppear()
        }
    }
}

#Preview {
    NavigationStack {
        PilotProfileView(viewModel: .init(container: .preview))
    }
}
