//
//  FinderFileCreatorApp.swift
//  FinderFileCreator

import SwiftUI

@main
struct FinderFileCreatorApp: App {
    private var library = TemplateLibrary()
    
    var body: some Scene {
        Window("", id: "MainWindow") {
            ContentView()
                .environment(library)
                .containerBackground(.thinMaterial.materialActiveAppearance(.active), for: .window)
                .windowFullScreenBehavior(.disabled)
                .preferredColorScheme(.dark)
                .frame(minWidth: 820, idealWidth: 900, maxWidth: .infinity, minHeight: 460, idealHeight: 560, maxHeight: .infinity)
        }
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandGroup(replacing: .newItem) {}
        }
    }
}

struct VisualEffectBlur: NSViewRepresentable {
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}
