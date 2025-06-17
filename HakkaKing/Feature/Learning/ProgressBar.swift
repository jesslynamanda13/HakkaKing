//
//  ProgressBar.swift
//  HakkaKing
//
//  Created by Amanda on 16/06/25.
//

import SwiftUI

struct ProgressBar: View {
    var progress: Int
    var total: Int = 4
    
    var body: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .fill(Color.white)
                .frame(height: 20)
                
            Capsule()
                .fill(Color.orange)
                .frame(width: CGFloat(progress) / CGFloat(total) * 280, height: 20)
        }
        .frame(width: 280, height: 20)
    }
}
