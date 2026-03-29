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
        isExtensionEnabled = FIFinderSyncController.isExtensionEnabled
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
