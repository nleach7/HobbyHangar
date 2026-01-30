//
//  LogbookView.swift
//  HobbyHangar
//
//  Created by Nick Leach on 1/21/26.
//

import SwiftUI
import FactoryKit

struct LogbookView: View {
    @Bindable private var viewModel: LogbookViewModel

    init(viewModel: LogbookViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Text("Logbook")
            .font(.title)
            .navigationTitle("Logbook")
    }
}

#Preview {
    NavigationStack {
        LogbookView(viewModel: .init())
    }.task {
        Container.shared.setupPreviewMocks()
    }
}
