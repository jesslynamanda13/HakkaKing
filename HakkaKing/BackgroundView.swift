//
//  BackgroundView.swift
//  HakkaKing
//
//  Created by Marshia on 16/06/25.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        Image("BG")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
    }
}

#Preview {
    BackgroundView()
}
