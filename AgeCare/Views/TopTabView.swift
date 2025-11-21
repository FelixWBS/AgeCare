//
//  TopTabView.swift
//  AgeCare
//
//  Created by Felix Weißleder on 21.11.25.
//
import SwiftUI
import SwiftData

struct TopTabView: View {
    @State private var selectedTab: Tabs = .home
    
    var body: some View {
        TabView(selection: $selectedTab){
            Tab("Home", systemImage: "house", value: .home){
                ContentView()
            }
        }
    }
}
