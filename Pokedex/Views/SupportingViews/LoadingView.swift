//
//  LoadingView.swift
//  Pokedex
//
//  Created by Elia Crocetta on 16/04/25.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        Color.black.opacity(0.1)
            .ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .red))
            .scaleEffect(x: 2, y: 2, anchor: .center)
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 10)
    }
}
