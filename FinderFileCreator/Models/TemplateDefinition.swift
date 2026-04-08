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
