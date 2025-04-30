//
//  PageView.swift
//  AnimatedStorybook
//
//  Created by Caleb Bellmyer on 4/30/25.
//
//

import SwiftUI

struct PageView: View {

    let page: Page
    let geometry: GeometryProxy
    let selectedTabId: UUID?

    @State private var isTextTapped: Bool = false
    @State private var currentImageScale: CGFloat = 1.0
    @State private var gestureImageScale: CGFloat = 1.0
    @State private var resetZoomWorkItem: DispatchWorkItem?

    private var isSelected: Bool {
        page.id == selectedTabId
    }
    
    private var totalImageScale: CGFloat {
         (isSelected ? 1.0 : 0.8) * currentImageScale * gestureImageScale
    }

    private func scheduleZoomReset() {
        resetZoomWorkItem?.cancel()
        let workItem = DispatchWorkItem {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                currentImageScale = 1.0
                gestureImageScale = 1.0
            }
        }
        resetZoomWorkItem = workItem

        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: workItem)
    }

    var body: some View {
        VStack {
            Spacer()

            // --- Image ---
            Group {
                if let imageName = page.imageName, !imageName.isEmpty {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .overlay(
                            Text("No Image Provided")
                                .foregroundColor(.gray)
                                .font(.caption)
                        )
                }
            }
            .frame(height: geometry.size.height * 0.4)
            .scaleEffect(totalImageScale)
            .opacity(isSelected ? 1.0 : 0.6)
            .padding(.bottom)
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        resetZoomWorkItem?.cancel()
                        resetZoomWorkItem = nil
                        gestureImageScale = value
                    }
                    .onEnded { value in
                        currentImageScale *= value
                        gestureImageScale = 1.0
                        scheduleZoomReset()
                    }
            )

            Text(page.text)
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.bottom)
                .opacity(isSelected ? 1.0 : 0.1)
                .offset(y: isSelected ? 0 : 30)
                .scaleEffect(isTextTapped ? 1.1 : 1.0)
                .onTapGesture {
                    if !isTextTapped {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.4)) {
                            isTextTapped = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            if isTextTapped {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.4)) {
                                    isTextTapped = false
                                }
                            }
                        }
                    }
                }

            Spacer()
        }
        .frame(width: geometry.size.width)
        .animation(.easeInOut(duration: 0.6), value: isSelected)
        .onChange(of: isSelected) { _, newValue in
            if !newValue {
                resetZoomWorkItem?.cancel()
                resetZoomWorkItem = nil
                isTextTapped = false
                withAnimation(.easeInOut(duration: 0.2)) {
                     currentImageScale = 1.0
                     gestureImageScale = 1.0
                }
            }
        }
    }
}

struct PageView_PreviewWrapper: View {
    let pages = samplePages
    @State private var previewSelectedTabId: UUID?

    init() {
        _previewSelectedTabId = State(initialValue: pages.first?.id)
    }

    var body: some View {
        GeometryReader { geometry in
            let currentPage = pages.first { $0.id == previewSelectedTabId } ?? pages.first!
            PageView(
                page: currentPage,
                geometry: geometry,
                selectedTabId: previewSelectedTabId
            )
            VStack {
                Spacer()
                HStack {
                    ForEach(Array(pages.enumerated()), id: \.element.id) { index, page in
                        Button("Page \(index + 1)") {
                            withAnimation(.easeInOut(duration: 0.6)) {
                                previewSelectedTabId = page.id
                            }
                        }
                        .padding(.horizontal, 5)
                    }
                }
                .padding()
                .background(.thinMaterial)
                .clipShape(Capsule())
                .padding(.bottom)
            }
        }
        .environment(\.colorScheme, .light)
    }
}

#Preview {
   PageView_PreviewWrapper()
}
