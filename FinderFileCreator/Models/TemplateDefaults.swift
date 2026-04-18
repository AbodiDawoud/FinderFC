//
//  TemplateDefaults.swift
//  FinderFileCreator
    

import Foundation

enum TemplateDefaults {
    static let swiftTemplate = TemplateDefinition(
        title: "Swift File",
        defaultFileName: "NewFile",
        fileExtension: "swift",
        content: """
        import Foundation

        struct {{fileBaseName}} {
            let createdAt = Date()
        }
        """,
        iconAssetName: "SwiftLang"
    )

    static let swiftUIViewTemplate = TemplateDefinition(
        title: "SwiftUI View",
        defaultFileName: "ContentView",
        fileExtension: "swift",
        content: """
        import SwiftUI

        struct {{fileBaseName}}: View {
            var body: some View {
                Text("{{folderName}}")
                    .padding()
            }
        }

        #Preview {
            {{fileBaseName}}()
        }
        """,
        iconAssetName: "SwiftLang"
    )

    static let swiftTestTemplate = TemplateDefinition(
        title: "Swift XCTest Case",
        defaultFileName: "AppTests",
        fileExtension: "swift",
        content: """
        import XCTest

        final class {{fileBaseName}}: XCTestCase {
            func testExample() throws {
                XCTAssertTrue(true)
            }
        }
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

    static let packageJSONTemplate = TemplateDefinition(
        title: "Package Manifest",
        defaultFileName: "package",
        fileExtension: "json",
        content: """
        {
          "name": "app",
          "version": "0.1.0",
          "private": true,
          "type": "module",
          "scripts": {
            "dev": "vite",
            "build": "vite build",
            "preview": "vite preview"
          },
          "dependencies": {},
          "devDependencies": {}
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

        struct VertexOut {
            float4 position [[position]];
            float2 uv;
        };

        fragment float4 fragment_main(VertexOut in [[stage_in]]) {
            return float4(in.uv, 0.0, 1.0);
        }
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

    static let entitlementsTemplate = TemplateDefinition(
        title: "App Entitlements",
        defaultFileName: "{{folderName}}",
        fileExtension: "entitlements",
        content: """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>com.apple.security.app-sandbox</key>
            <true/>
            <key>com.apple.security.files.user-selected.read-write</key>
            <true/>
        </dict>
        </plist>
        """,
        iconAssetName: "EntitlementsFile"
    )

    static let xcconfigTemplate = TemplateDefinition(
        title: "Xcode Build Settings",
        defaultFileName: "Debug",
        fileExtension: "xcconfig",
        content: """
        PRODUCT_NAME = $(TARGET_NAME)
        SWIFT_VERSION = 5.0
        ENABLE_USER_SCRIPT_SANDBOXING = YES
        OTHER_SWIFT_FLAGS = $(inherited)
        """,
        iconAssetName: "TextFile"
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
        :root {
            color-scheme: light dark;
            font-family: system-ui, sans-serif;
        }

        body {
            margin: 0;
            min-height: 100vh;
            background: Canvas;
            color: CanvasText;
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

    static let typeScriptTemplate = TemplateDefinition(
        title: "TypeScript Module",
        defaultFileName: "index",
        fileExtension: "ts",
        content: """
        type Result<T> = {
            data: T
            createdAt: string
        }

        export function createResult<T>(data: T): Result<T> {
            return {
                data,
                createdAt: new Date().toISOString(),
            }
        }
        """,
        iconAssetName: "TypeScript"
    )

    static let reactComponentTemplate = TemplateDefinition(
        title: "React Component",
        defaultFileName: "FeatureCard",
        fileExtension: "tsx",
        content: """
        import type { ReactNode } from "react"

        type {{fileBaseName}}Props = {
            title: string
            children?: ReactNode
        }

        export function {{fileBaseName}}({ title, children }: {{fileBaseName}}Props) {
            return (
                <section>
                    <h2>{title}</h2>
                    {children}
                </section>
            )
        }
        """,
        iconAssetName: "Tsx"
    )

    static let viteConfigTemplate = TemplateDefinition(
        title: "Vite Config",
        defaultFileName: "vite.config",
        fileExtension: "ts",
        content: """
        import { defineConfig } from "vite"
        import react from "@vitejs/plugin-react"

        export default defineConfig({
            plugins: [react()],
        })
        """,
        iconAssetName: "TypeScript"
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

    static let composeScreenTemplate = TemplateDefinition(
        title: "Jetpack Compose Screen",
        defaultFileName: "MainScreen",
        fileExtension: "kt",
        content: """
        package com.example.app

        import androidx.compose.foundation.layout.padding
        import androidx.compose.material3.Scaffold
        import androidx.compose.material3.Text
        import androidx.compose.runtime.Composable
        import androidx.compose.ui.Modifier
        import androidx.compose.ui.tooling.preview.Preview

        @Composable
        fun {{fileBaseName}}() {
            Scaffold { padding ->
                Text(
                    text = "{{folderName}}",
                    modifier = Modifier.padding(padding)
                )
            }
        }

        @Preview(showBackground = true)
        @Composable
        private fun {{fileBaseName}}Preview() {
            {{fileBaseName}}()
        }
        """,
        iconAssetName: "Kotlin"
    )

    static let androidManifestTemplate = TemplateDefinition(
        title: "Android Manifest",
        defaultFileName: "AndroidManifest",
        fileExtension: "xml",
        content: """
        <?xml version="1.0" encoding="utf-8"?>
        <manifest xmlns:android="http://schemas.android.com/apk/res/android">
            <application
                android:allowBackup="true"
                android:label="{{folderName}}"
                android:supportsRtl="true"
                android:theme="@style/Theme.App" />
        </manifest>
        """,
        iconAssetName: "XmlFile"
    )

    static let androidStringsTemplate = TemplateDefinition(
        title: "Android Strings",
        defaultFileName: "strings",
        fileExtension: "xml",
        content: """
        <?xml version="1.0" encoding="utf-8"?>
        <resources>
            <string name="app_name">{{folderName}}</string>
        </resources>
        """,
        iconAssetName: "XmlFile"
    )

    static let gradleKotlinTemplate = TemplateDefinition(
        title: "Gradle Kotlin Build",
        defaultFileName: "build.gradle",
        fileExtension: "kts",
        content: """
        plugins {
            id("com.android.application")
            id("org.jetbrains.kotlin.android")
        }

        android {
            namespace = "com.example.app"
            compileSdk = 35

            defaultConfig {
                applicationId = "com.example.app"
                minSdk = 24
                targetSdk = 35
                versionCode = 1
                versionName = "1.0"
            }
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

    static let yamlTemplate = TemplateDefinition(
        title: "YAML Config",
        defaultFileName: "config",
        fileExtension: "yml",
        content: """
        name: {{folderName}}
        created: {{date}}
        settings:
          enabled: true
        """,
        iconAssetName: "YamlFile"
    )

    static let shellTemplate = TemplateDefinition(
        title: "Shell Script",
        defaultFileName: "script",
        fileExtension: "sh",
        content: """
        #!/usr/bin/env bash
        set -euo pipefail

        echo "{{folderName}}"
        """,
        iconAssetName: "Shell"
    )

    static let pythonTemplate = TemplateDefinition(
        title: "Python Script",
        defaultFileName: "main",
        fileExtension: "py",
        content: """
        def main() -> None:
            print("{{folderName}}")


        if __name__ == "__main__":
            main()
        """,
        iconAssetName: "Python"
    )

    static let sqlTemplate = TemplateDefinition(
        title: "SQL Query",
        defaultFileName: "query",
        fileExtension: "sql",
        content: """
        -- Created {{date}} for {{folderName}}

        SELECT *
        FROM table_name
        LIMIT 100;
        """,
        iconAssetName: "Sql"
    )

    static let gitignoreTemplate = TemplateDefinition(
        title: "Git Ignore",
        defaultFileName: ".gitignore",
        fileExtension: "",
        content: """
        .DS_Store
        build/
        dist/
        .env
        *.log
        """,
        iconAssetName: "gitignore"
    )

    static let appleTemplates: [TemplateDefinition] = [
        swiftUIViewTemplate,
        swiftTemplate,
        swiftTestTemplate,
        metalTemplate,
        plistTemplate,
        entitlementsTemplate,
        xcconfigTemplate,
        markdownTemplate
    ]

    static let webTemplates: [TemplateDefinition] = [
        htmlTemplate,
        cssTemplate,
        typeScriptTemplate,
        reactComponentTemplate,
        jsTemplate,
        packageJSONTemplate,
        viteConfigTemplate,
        markdownTemplate
    ]

    static let androidTemplates: [TemplateDefinition] = [
        composeScreenTemplate,
        kotlinTemplate,
        javaTemplate,
        androidManifestTemplate,
        androidStringsTemplate,
        gradleKotlinTemplate,
        jsonTemplate,
        markdownTemplate
    ]

    static let generalTemplates: [TemplateDefinition] = [
        textTemplate,
        markdownTemplate,
        jsonTemplate,
        yamlTemplate,
        shellTemplate,
        pythonTemplate,
        sqlTemplate,
        gitignoreTemplate
    ]

    static let templates: [TemplateDefinition] = [
        textTemplate,
        markdownTemplate,
        jsonTemplate,
        yamlTemplate,
        swiftTemplate,
        htmlTemplate,
        typeScriptTemplate,
        pythonTemplate
    ]
}
