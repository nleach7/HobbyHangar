//
//  RootView.swift
//  HobbyHangar
//
//  Created by Nick Leach on 1/15/26.
//

import SwiftUI

struct RootView: View {

    private var viewModel: RootViewModel

    init(viewModel: RootViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            mainView()
        }
    }

    @ViewBuilder
    func mainView() -> some View {
        if let displayText = viewModel.displayText {
            Text(displayText)
                .font(.largeTitle)
        } else {
            ProgressView()
        }
    }
}

#if DEBUG
#Preview {
    RootView(viewModel: .init(container: .preview))
}
#endif
