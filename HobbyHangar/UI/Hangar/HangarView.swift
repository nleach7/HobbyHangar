//
//  HangarView.swift
//  HobbyHangar
//
//  Created by Nick Leach on 1/21/26.
//

import SwiftUI
import FactoryKit

struct HangarView: View {
    @Bindable private var viewModel: HangarViewModel

    init(viewModel: HangarViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Text("Hangar")
            .font(.title)
            .navigationTitle("Hangar")
    }
}

#Preview {
    NavigationStack {
        HangarView(viewModel: .init())
    }.task {
        Container.shared.setupPreviewMocks()
    }
}
