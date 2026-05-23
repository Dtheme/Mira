//
//  MiLaunchView.swift
//  Mira
//
//  Created on 2026/5/23.
//

import SwiftUI

struct MiLaunchView: View {
    var onFinish: () -> Void

    @State private var logoScale: CGFloat = 0.6
    @State private var logoOpacity: Double = 0.0
    @State private var logoGlow: Double = 0.0
    
    @State private var titleOpacity: Double = 0.0
    @State private var titleTracking: CGFloat = 16.0
    
    @State private var sloganOpacity: Double = 0.0
    @State private var sloganOffset: CGFloat = 14.0
    
    @State private var blob1Offset = CGSize(width: -120, height: -180)
    @State private var blob2Offset = CGSize(width: 140, height: 180)
    @State private var blob3Offset = CGSize(width: -60, height: 120)
    
    var body: some View {
        ZStack {
            Color(hex: 0xF7FDFF)
                .ignoresSafeArea()
            
            ZStack {
                Circle()
                    .fill(MiColorTokens.appleBlue500.opacity(0.12))
                    .frame(width: 260, height: 260)
                    .blur(radius: 60)
                    .offset(blob1Offset)
                
                Circle()
                    .fill(MiColorTokens.aqua400.opacity(0.10))
                    .frame(width: 240, height: 240)
                    .blur(radius: 55)
                    .offset(blob2Offset)
                
                Circle()
                    .fill(MiColorTokens.iris500.opacity(0.08))
                    .frame(width: 220, height: 240)
                    .blur(radius: 50)
                    .offset(blob3Offset)
            }
            .allowsHitTesting(false)
            
            VStack(spacing: 0) {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(MiColorTokens.appleBlue500.opacity(0.18))
                        .frame(width: 120, height: 120)
                        .blur(radius: 18)
                        .opacity(logoGlow)
                    
                    Image("app_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 96, height: 96)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                }
                .padding(.bottom, 22)
                
                Text("Mira")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .tracking(titleTracking)
                    .foregroundStyle(MiColorTokens.contentPrimary)
                    .opacity(titleOpacity)
                    .offset(x: titleTracking / 2)
                    .padding(.bottom, 8)
                
                Text("Design Styles, Made Native")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(MiColorTokens.contentSecondary)
                    .opacity(sloganOpacity)
                    .offset(y: sloganOffset)
                
                Spacer()
                    .frame(height: 108)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeOut(duration: 4.5).repeatForever(autoreverses: true)) {
            blob1Offset = CGSize(width: 100, height: -140)
            blob2Offset = CGSize(width: -120, height: 120)
            blob3Offset = CGSize(width: 80, height: 60)
        }
        
        withAnimation(.spring(response: 0.76, dampingFraction: 0.74, blendDuration: 0)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }
        
        withAnimation(.easeIn(duration: 0.6).delay(0.2)) {
            logoGlow = 0.54
        }
        
        withAnimation(.easeOut(duration: 0.9).delay(0.35)) {
            titleOpacity = 1.0
            titleTracking = 2.4
        }
        
        withAnimation(.spring(response: 0.65, dampingFraction: 0.82, blendDuration: 0).delay(0.6)) {
            sloganOpacity = 1.0
            sloganOffset = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.85) {
            onFinish()
        }
    }
}
