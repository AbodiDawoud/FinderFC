//
//  TemplateDefaults.swift
//  FinderFileCreator
    

import Foundation

enum TemplateDefaults {
    static let swiftTemplate = TemplateDefinition(
        title: "Swift File",
        defaultFileName: "New Swift File",
        fileExtension: "swift",
        content: """
        import Foundation

        print("Hello, World!")
        """,
        iconAssetName: "SwiftLang"
    )
    
    static let markdownTemplate = TemplateDefinition(
        title: "Markdown Notes",
        defaultFileName: "{{date}} Notes",
        fileExtension: "md",
        content: """
        # {{folderName}}

        Created: {{date}} {{time}}
        """,
        iconAssetName: "MarkdownFile"
    )
    
    static let jsonTemplate = TemplateDefinition(
        title: "JSON File",
        defaultFileName: "config",
        fileExtension: "json",
        content: """
        {

        }
        """,
        iconAssetName: "Json"
    )
    
    static let textTemplate = TemplateDefinition(
        title: "Plain Text",
        defaultFileName: "New File",
        fileExtension: "txt",
        content: "",
        iconAssetName: "TextFile"
    )
    
    static let metalTemplate = TemplateDefinition(
        title: "Metal Shader",
        defaultFileName: "Shader",
        fileExtension: "metal",
        content: """
        #include <metal_stdlib>
        using namespace metal;

        """,
        iconAssetName: "metal"
    )
    
    static let plistTemplate = TemplateDefinition(
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
    )
    
    static let htmlTemplate = TemplateDefinition(
        title: "HTML Document",
        defaultFileName: "index",
        fileExtension: "html",
        content: """
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>{{folderName}}</title>
        </head>
        <body>
            
        </body>
        </html>
        """,
        iconAssetName: "html"
    )
    
    static let cssTemplate = TemplateDefinition(
        title: "CSS Stylesheet",
        defaultFileName: "styles",
        fileExtension: "css",
        content: """
        body {
            margin: 0;
            padding: 0;
        }
        """,
        iconAssetName: "css"
    )
    
    static let jsTemplate = TemplateDefinition(
        title: "JavaScript File",
        defaultFileName: "script",
        fileExtension: "js",
        content: """
        console.log("Hello from {{fileName}}");
        """,
        iconAssetName: "JavaScript"
    )
    
    static let kotlinTemplate = TemplateDefinition(
        title: "Kotlin Class",
        defaultFileName: "NewClass",
        fileExtension: "kt",
        content: """
        package com.example.app

        class {{fileBaseName}} {
            
        }
        """,
        iconAssetName: "Kotlin"
    )
    
    static let javaTemplate = TemplateDefinition(
        title: "Java Class",
        defaultFileName: "NewClass",
        fileExtension: "java",
        content: """
        public class {{fileBaseName}} {
            public static void main(String[] args) {
                System.out.println("Hello, World!");
            }
        }
        """,
        iconAssetName: "Java"
    )
    
    static let xmlTemplate = TemplateDefinition(
        title: "XML Document",
        defaultFileName: "layout",
        fileExtension: "xml",
        content: """
        <?xml version="1.0" encoding="utf-8"?>
        <resources>
            
        </resources>
        """,
        iconAssetName: "XmlFile"
    )

    static let templates: [TemplateDefinition] = [
        swiftTemplate,
        markdownTemplate,
        jsonTemplate,
        textTemplate,
        metalTemplate,
        plistTemplate
    ]
}
