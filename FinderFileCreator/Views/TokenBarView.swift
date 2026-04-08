//
//  TokenBarView.swift
//  FinderFileCreator
    

import SwiftUI

struct TokenBarView: View {
    let tokens = [
        "{{date}}", "{{time}}", "{{year}}", "{{month}}", "{{day}}",
        "{{hour}}", "{{minute}}", "{{second}}", "{{user}}", "{{uuid}}",
        "{{folderName}}", "{{fileBaseName}}", "{{fileName}}"
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(tokens, id: \.self) { token in
                    Text(token)
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.15))
                        .cornerRadius(6)
                        .onDrag { NSItemProvider(object: token as NSString) }
                        .help("Drag to insert \(token)")
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal, 22)
    }
}
