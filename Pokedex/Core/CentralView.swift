//
//  CentralView.swift
//  Pokedex
//
//  Created by Elia Crocetta on 15/04/25.
//

import SwiftUI

struct CentralView: View {
    @StateObject var coordinator = PokedexCoordinator(path: NavigationPath())
    @Environment(\.urlSession) private var urlSession
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.start(urlSession: urlSession)
                .navigationDestination(for: Screen.self) { screen in
                    coordinator.create(screen: screen, urlSession: urlSession)
                        .sheet(item: $coordinator.sheet) { sheet in
                            coordinator.create(sheet: sheet, urlSession: urlSession)
                        }
                }
        }
        .environmentObject(coordinator)
    }
    
}

#Preview {
    CentralView()
}
