//
//  StoryBookView.swift
//  AnimatedStorybook
//
//  Created by Caleb Bellmyer on 4/30/25.
//
//

import SwiftUI

struct StoryBookView: View {
    let pages: [Page]
    @State private var selectedTab: UUID? = nil

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(pages) { page in
                GeometryReader { geometry in
                    PageView(
                        page: page,
                        geometry: geometry,
                        selectedTabId: selectedTab
                    )
                }
                .tag(page.id as UUID?)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .ignoresSafeArea()
        .onAppear {
            if selectedTab == nil, let firstPageId = pages.first?.id {

                DispatchQueue.main.async {
                    selectedTab = firstPageId
                    print("--- StoryBookView appeared. Initial selectedTab set (delayed) to: \(selectedTab?.uuidString ?? "nil")") // Optional debug print
                }
            }
        }
    }
}

#Preview {
    StoryBookView(pages: samplePages)
}
