//
//  FinderFileCreatorApp.swift
//  FinderFileCreator

import SwiftUI

@main
struct FinderFileCreatorApp: App {
    private var library = TemplateLibrary()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(library)
                .containerBackground(.thinMaterial, for: .window)
                .windowMinimizeBehavior(.disabled)
                .windowFullScreenBehavior(.disabled)
                //.windowResizeBehavior(.disabled)
                .frame(minWidth: 850, idealWidth: 920, maxWidth: .infinity, minHeight: 500, idealHeight: 600, maxHeight: .infinity)
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
