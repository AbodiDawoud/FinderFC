//
//  TemplateRenderer.swift
//  FinderFileCreator
    

import Foundation

/// Resolves template placeholders into concrete file names and file contents
/// using folder context and the current date and time.
enum TemplateRenderer {
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    /// Produces the file's base name by expanding supported placeholders in the
    /// template's default name and trimming surrounding whitespace.
    static func resolvedBaseName(for template: TemplateDefinition, folderName: String, now: Date = Date()) -> String {
        let raw = template.defaultFileName.trimmingCharacters(in: .whitespacesAndNewlines)
        let fallback = raw.isEmpty ? "New File" : raw

        return replaceTokens(
            in: fallback,
            values: [
                "{{date}}": dateFormatter.string(from: now),
                "{{time}}": timeFormatter.string(from: now),
                "{{year}}": String(Calendar.current.component(.year, from: now)),
                "{{folderName}}": folderName,
                "{{fileBaseName}}": fallback,
                "{{fileName}}": fallback,
            ]
        )
        .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Produces the final file name, including a sanitized extension when the
    /// template defines one.
    static func resolvedFileName(for template: TemplateDefinition, folderName: String, now: Date = Date()) -> String {
        let baseName = resolvedBaseName(for: template, folderName: folderName, now: now).nonEmpty ?? "New File"
        let sanitizedExtension = template.fileExtension.sanitizedExtension

        guard !sanitizedExtension.isEmpty else {
            return baseName
        }

        return "\(baseName).\(sanitizedExtension)"
    }

    /// Produces the file contents by replacing supported placeholders with
    /// values derived from the destination folder and current timestamp.
    static func resolvedContent(for template: TemplateDefinition, folderName: String, now: Date = Date()) -> String {
        let baseName = resolvedBaseName(for: template, folderName: folderName, now: now).nonEmpty ?? "New File"
        let fileName = resolvedFileName(for: template, folderName: folderName, now: now)

        return replaceTokens(
            in: template.content,
            values: [
                "{{date}}": dateFormatter.string(from: now),
                "{{time}}": timeFormatter.string(from: now),
                "{{year}}": String(Calendar.current.component(.year, from: now)),
                "{{folderName}}": folderName,
                "{{fileBaseName}}": baseName,
                "{{fileName}}": fileName,
            ]
        )
    }

    private static func replaceTokens(in string: String, values: [String: String]) -> String {
        values.reduce(string) { partialResult, entry in
            partialResult.replacingOccurrences(of: entry.key, with: entry.value)
        }
    }
}
