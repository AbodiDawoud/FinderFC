//
//  SharedTemplateStore.swift
//  FinderFileCreator
    

import Foundation

/// Persists shared template definitions in the app group's container so the app
/// and extension can read the same template library.
enum SharedTemplateStore {
    static let appGroupID = "group.com.app.FinderFileCreator.shared"
    private static let relativePath = "TemplateStudio/templates.json"

    /// Loads the saved template library from shared storage, or falls back to
    /// the bundled defaults when no valid persisted data is available.
    static func load() -> [TemplateDefinition] {
        guard
            let fileURL = storageURL(createIfNeeded: false),
            let data = try? Data(contentsOf: fileURL),
            let templates = try? JSONDecoder().decode([TemplateDefinition].self, from: data),
            !templates.isEmpty
        else {
            return TemplateDefaults.templates
        }

        return templates
    }

    /// Writes the current template library to shared storage for use across
    /// the app and its extension targets.
    static func save(_ templates: [TemplateDefinition]) {
        guard let fileURL = storageURL(createIfNeeded: true) else { return }

        do {
            let data = try JSONEncoder.prettyPrinted.encode(templates)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            assertionFailure("Failed to save templates: \(error.localizedDescription)")
        }
    }

    /// Returns the location for the shared group folder
    static func sharedGroupPath() -> String {
        storageURL(createIfNeeded: false)?.path(percentEncoded: false) ?? "/"
    }

    
    private static func storageURL(createIfNeeded: Bool) -> URL? {
        let fileManager = FileManager.default
        let applicationSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first?
                                               .appendingPathComponent("FinderFileCreator", isDirectory: true)
        let baseURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) ?? applicationSupportURL

        guard let baseURL else { return nil }

        do {
            if createIfNeeded {
                try fileManager.createDirectory(at: baseURL, withIntermediateDirectories: true)
            }
            
            let directoryURL = baseURL.appendingPathComponent("TemplateStudio", isDirectory: true)
            
            if createIfNeeded {
                try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
            }
            
            return baseURL.appending(path: relativePath)
        } catch {
            return nil
        }
    }
}
