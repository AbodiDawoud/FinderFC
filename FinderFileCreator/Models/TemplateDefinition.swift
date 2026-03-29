//
//  TemplateDefinition.swift
//  FinderFileCreator

import Foundation


struct TemplateDefinition: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String
    var defaultFileName: String
    var fileExtension: String
    var content: String
    var iconAssetName: String
    var isEnabled: Bool

    init(
        id: UUID = UUID(),
        title: String,
        defaultFileName: String,
        fileExtension: String,
        content: String,
        iconAssetName: String,
        isEnabled: Bool = true
    ) {
        self.id = id
        self.title = title
        self.defaultFileName = defaultFileName
        self.fileExtension = fileExtension
        self.content = content
        self.iconAssetName = iconAssetName
        self.isEnabled = isEnabled
    }
}

enum TemplateDefaults {
    static let templates: [TemplateDefinition] = [
        TemplateDefinition(
            title: "Swift File",
            defaultFileName: "New Swift File",
            fileExtension: "swift",
            content: """
            import Foundation

            print("Hello, World!")
            """,
            iconAssetName: "SwiftLang"
        ),
        
        TemplateDefinition(
            title: "Markdown Notes",
            defaultFileName: "{{date}} Notes",
            fileExtension: "md",
            content: """
            # {{folderName}}

            Created: {{date}} {{time}}
            """,
            iconAssetName: "MarkdownFile"
        ),
        
        TemplateDefinition(
            title: "JSON File",
            defaultFileName: "config",
            fileExtension: "json",
            content: """
            {

            }
            """,
            iconAssetName: "Json"
        ),
        
        TemplateDefinition(
            title: "Plain Text",
            defaultFileName: "New File",
            fileExtension: "txt",
            content: "",
            iconAssetName: "TextFile"
        ),
        
        TemplateDefinition(
            title: "Metal Shader",
            defaultFileName: "Shader",
            fileExtension: "metal",
            content: """
            #include <metal_stdlib>
            using namespace metal;

            """,
            iconAssetName: "metal"
        ),
        
        TemplateDefinition(
            title: "Property List",
            defaultFileName: "Info",
            fileExtension: "plist",
            content: """
            <?xml version="1.0" encoding="UTF-8"?>
            <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
            <plist version="1.0">
            <dict>
            </dict>
            </plist>
            """,
            iconAssetName: "Plist"
        ),
    ]
}
