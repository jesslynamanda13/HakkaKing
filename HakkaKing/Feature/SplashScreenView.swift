//
//  SplashSCreenView.swift
//  WangHakka
//
//  Created by Shierly Anastasya Lie on 17/06/25.
//

import SwiftUI
import AVFoundation

struct SplashScreenView: View {
    @State var isActive: Bool = false
    
    var body: some View {
        ZStack {
            if self.isActive {
                WelcomeView()
            } else {
                //SplashScreen
                VStack {
                    VStack {
                        GIFView(gifName: "SplashScreen")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    //background
                    
                }.onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 9.5) {
                        withAnimation{
                            self.isActive = true
                        }
                    }
                }
                
            }
        }
    }
}


