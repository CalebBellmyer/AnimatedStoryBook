//
//  ContentView.swift
//  AnimatedStorybook
//
//  Created by Caleb Bellmyer on 4/30/25.
//
//

import SwiftUI


struct ContentView: View {
    @State private var colorSchemeOverride: ColorScheme? = nil
    @Environment(\.colorScheme) var currentScheme
    @State private var overlayOpacity: Double = 0.0
    @State private var previousSchemeSnapshot: ColorScheme = .light
    private var overlayBackgroundColor: Color {
        previousSchemeSnapshot == .dark ? Color(UIColor.systemBackground) : Color(UIColor.systemBackground)
    }

    private var toggleButtonIconName: String {
        let nextScheme: ColorScheme
        if let override = colorSchemeOverride {
            nextScheme = (override == .light) ? .dark : .light
        } else {
            nextScheme = (currentScheme == .light) ? .dark : .light
        }
        return nextScheme == .light ? "sun.max.fill" : "moon.fill"
    }

    var body: some View {
        ZStack(alignment: .top) {
            StoryBookView(pages: samplePages)
                .preferredColorScheme(colorSchemeOverride)
            Button {
                let newOverride: ColorScheme?
                if let currentOverride = colorSchemeOverride {
                    newOverride = (currentOverride == .light) ? .dark : .light
                } else {
                    newOverride = (currentScheme == .light) ? .dark : .light
                }
                colorSchemeOverride = newOverride

            } label: {
                Image(systemName: toggleButtonIconName)
                    .font(.title2)
                    .padding(10)
                    .background(.regularMaterial)
                    .clipShape(Circle())
                    .shadow(radius: 3)
            }
            .padding(.top, 10)

            Rectangle()
                .fill(overlayBackgroundColor)
                .opacity(overlayOpacity)
                .ignoresSafeArea()
                .allowsHitTesting(false)
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .onChange(of: currentScheme) { oldScheme, newScheme in
            if oldScheme != newScheme {
                 previousSchemeSnapshot = oldScheme
                 overlayOpacity = 1.0
                 withAnimation(.easeInOut(duration: 0.6)) {
                     overlayOpacity = 0.0
                 }
            }
        }
        .onAppear {
             previousSchemeSnapshot = currentScheme
        }
    }
}

#Preview {
    ContentView()
}
