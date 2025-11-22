//
//  OnboardingView.swift
//  AgeCare
//
//  Created by Felix Weißleder on 22.11.25.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        NavigationStack{
            Spacer()
            
            NavigationLink {
                TopTabView()
                    .navigationBarBackButtonHidden()
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 80, height: 80)
                        .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
                    Text("🧓")
                    
                }
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Senior")
            Text("Senior")
                .bold()
            Spacer()
            NavigationLink{
                TopTabRelative()
                    .navigationBarBackButtonHidden()
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 80, height: 80)
                        .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
                    Text("🤝")
                    
                }
            }
            .buttonStyle(.plain)
            .accessibilityLabel("relative")
            Text("Relative")
                .bold()
            Spacer()
        }
    }
}

#Preview {
    OnboardingView()
}
