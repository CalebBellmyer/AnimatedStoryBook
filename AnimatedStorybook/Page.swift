//
//  Page.swift
//  AnimatedStorybook
//
//  Created by Caleb Bellmyer on 4/30/25.
//

import Foundation
import SwiftUI

struct Page: Identifiable {
    let id = UUID()
    let text: String
    let imageName: String?
    
    init(text: String, imageName: String? = nil) {
        self.text = text
        self.imageName = imageName
    }
}

let samplePages = [
    Page(text: "Once upon a time, in a land far away...", imageName: "land_far_away"),
        Page(text: "There lived a curious rabbit named Hoppy.", imageName: "rabbit"),
        Page(text: "Hoppy loved exploring the magical forest.", imageName: "magic_forest"),
        Page(text: "The End.", imageName: "end")
    ]
