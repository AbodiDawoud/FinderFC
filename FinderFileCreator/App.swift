//
//  FinderFileCreatorApp.swift
//  FinderFileCreator

import SwiftUI

@main
struct FinderFileCreatorApp: App {
    private var library = TemplateLibrary()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some Scene {
        Window("", id: "MainWindow") {
            Group {
                if hasCompletedOnboarding {
                    ContentView()
                        .frame(minWidth: 820, idealWidth: 900, maxWidth: .infinity, minHeight: 460, idealHeight: 560, maxHeight: .infinity)
                } else {
                    OnboardingView()
                        .windowDismissBehavior(.disabled)
                        .windowResizeBehavior(.disabled)
                        .windowMinimizeBehavior(.disabled)
                        .windowFullScreenBehavior(.disabled)
                        .frame(width: 600, height: 450)
                }
            }
            .environment(library)
            .containerBackground(.thinMaterial.materialActiveAppearance(.active), for: .window)
            .preferredColorScheme(.dark)
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
