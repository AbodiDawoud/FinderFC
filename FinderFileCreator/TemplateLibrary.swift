//
//  TemplateLibrary.swift
//  FinderFileCreator

import FinderSync
import SwiftUI
import Observation


@MainActor
@Observable
final class TemplateLibrary {
    var templates: [TemplateDefinition]
    var selectedTemplateID: TemplateDefinition.ID?
    var isExtensionEnabled: Bool

    init() {
        let loadedTemplates = SharedTemplateStore.load()
        templates = loadedTemplates
        selectedTemplateID = loadedTemplates.first?.id
        isExtensionEnabled = FIFinderSyncController.isExtensionEnabled
    }

    var selectedTemplate: TemplateDefinition? {
        guard let selectedTemplateID else { return nil }
        return templates.first { $0.id == selectedTemplateID }
    }

    var enabledTemplateCount: Int {
        templates.filter(\.isEnabled).count
    }

    var disabledTemplateCount: Int {
        templates.count - enabledTemplateCount
    }

    func refreshExtensionStatus() {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.6)) {
            isExtensionEnabled = FIFinderSyncController.isExtensionEnabled
        }
    }

    func createTemplate(from url: URL) {
        guard let content = try? String(contentsOf: url, encoding: .utf8) else { return }
        
        let fileName = url.deletingPathExtension().lastPathComponent
        let fileExtension = url.pathExtension
        let title = fileName.isEmpty ? "New Template" : fileName
        let iconName = icon(for: fileExtension)
        
        let newTemplate = TemplateDefinition(
            title: title,
            defaultFileName: fileName,
            fileExtension: fileExtension,
            content: content,
            iconAssetName: iconName
        )

        templates.insert(newTemplate, at: 0)
        selectedTemplateID = newTemplate.id
        persist()
    }

    private func icon(for ext: String) -> String {
        switch ext.lowercased() {
        case "swift": return "SwiftLang"
        case "md": return "MarkdownFile"
        case "json": return "Json"
        case "metal": return "metal"
        case "plist": return "Plist"
        case "js": return "JavaScript"
        case "ts": return "TypeScript"
        case "tsx": return "Tsx"
        case "jsx": return "Jsx"
        case "html": return "html"
        case "css": return "css"
        case "py": return "Python"
        case "rb": return "Ruby"
        case "java": return "Java"
        case "php": return "Php"
        case "c": return "c"
        case "cpp": return "cpp"
        case "h", "hpp": return "cppHeader"
        case "m": return "m"
        case "mm": return "Objective-C"
        case "sh": return "Shell"
        case "xml": return "XmlFile"
        case "yml", "yaml": return "YamlFile"
        case "sql": return "Sql"
        case "go": return "GoLang"
        case "rs": return "Rust"
        case "dart": return "Dart"
        case "kt": return "Kotlin"
        case "cs": return "CsharpLang"
        case "scala": return "Scala"
        case "storyboard", "xib": return "StoryboardFile"
        case "entitlements": return "EntitlementsFile"
        default: return "TextFile"
        }
    }

    func addNewTemplate() {
        let newTemplate = TemplateDefinition(
            title: "New Template",
            defaultFileName: "Untitled",
            fileExtension: "txt",
            content: "",
            iconAssetName: "TextFile"
        )

        templates.insert(newTemplate, at: 0)
        selectedTemplateID = newTemplate.id
        persist()
    }

    func duplicateSelectedTemplate() {
        guard let selectedTemplate else { return }
        duplicateTemplate(id: selectedTemplate.id)
    }

    func duplicateTemplate(id: TemplateDefinition.ID) {
        guard let selectedTemplate = templates.first(where: { $0.id == id }) else { return }

        var duplicate = selectedTemplate
        duplicate.id = UUID()
        duplicate.title += " Copy"

        if let selectedIndex = templates.firstIndex(where: { $0.id == selectedTemplate.id }) {
            templates.insert(duplicate, at: selectedIndex + 1)
        } else {
            templates.append(duplicate)
        }

        selectedTemplateID = duplicate.id
        persist()
    }

    func deleteSelectedTemplate() {
        guard let selectedTemplateID else { return }
        deleteTemplate(id: selectedTemplateID)
    }

    func deleteTemplate(id: TemplateDefinition.ID) {
        templates.removeAll(where: { $0.id == id })

        if templates.isEmpty {
            templates = TemplateDefaults.templates
        }

        if selectedTemplateID == id {
            selectedTemplateID = templates.first?.id
        }

        persist()
    }

    func resetToDefaults() {
        templates = TemplateDefaults.templates
        selectedTemplateID = templates.first?.id
        persist()
    }

    func updateSelectedTemplate(_ update: (inout TemplateDefinition) -> Void) {
        guard let selectedTemplateID, let index = templates.firstIndex(where: { $0.id == selectedTemplateID }) else { return }

        update(&templates[index])
        persist()
    }

    func moveTemplates(fromOffsets source: IndexSet, toOffset destination: Int) {
        templates.move(fromOffsets: source, toOffset: destination)
        persist()
    }

    func moveTemplate(id: TemplateDefinition.ID, to targetID: TemplateDefinition.ID) {
        guard id != targetID else { return }
        guard let sourceIndex = templates.firstIndex(where: { $0.id == id }),
              let destinationIndex = templates.firstIndex(where: { $0.id == targetID }) else { return }
        
        let targetOffset = sourceIndex < destinationIndex ? destinationIndex + 1 : destinationIndex
        templates.move(fromOffsets: IndexSet(integer: sourceIndex), toOffset: targetOffset)
        persist()
    }

    func toggleTemplateEnabled(id: TemplateDefinition.ID) {
        guard let index = templates.firstIndex(where: { $0.id == id }) else { return }
        templates[index].isEnabled.toggle()
        persist()
    }

    func setTemplateIcon(id: TemplateDefinition.ID, assetName: String) {
        guard let index = templates.firstIndex(where: { $0.id == id }) else { return }
        templates[index].iconAssetName = assetName
        persist()
    }

    private func persist() {
        SharedTemplateStore.save(templates)
    }
}
