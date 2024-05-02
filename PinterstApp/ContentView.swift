//
//  ContentView.swift
//  PinterstApp
//
//  Created by Vladimir Pisarenko on 02.05.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
        //always light theme
            .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
 
