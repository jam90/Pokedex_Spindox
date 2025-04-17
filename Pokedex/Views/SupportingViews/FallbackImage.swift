//
//  FallbackImage.swift
//  Pokedex
//
//  Created by Elia Crocetta on 16/04/25.
//

import SwiftUI

struct FallbackImage: View {
    var size: CGFloat
    
    var body: some View {
        Image("pokeball")
            .resizable()
            .frame(width: size, height: size)
            .aspectRatio(contentMode: .fit)
    }
}
