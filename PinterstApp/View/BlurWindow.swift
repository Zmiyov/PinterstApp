//
//  BlurWindow.swift
//  PinterstApp
//
//  Created by Vladimir Pisarenko on 02.05.2024.
//

import SwiftUI

struct BlurWindow: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.blendingMode = .behindWindow
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
         
    }
}

#Preview {
    BlurWindow()
}
