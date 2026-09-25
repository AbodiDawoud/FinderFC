//
//  FinderSync.swift
//  Extension

import Cocoa
import Darwin
import FinderSync
import os


class FinderSync: FIFinderSync {
    private let copyPathLogger = Logger(subsystem: "com.app.FinderFileCreator.Exten", category: "CopyPath")

    override init() {
        super.init()

        let rootURL = URL(fileURLWithPath: "/")
        FIFinderSyncController.default().directoryURLs = Set([rootURL])

        NSLog("FinderSync initialized")
        NSLog("Monitoring root directory for global coverage")
    }

    override func menu(for menu: FIMenuKind) -> NSMenu? {
        guard let targetFolder = targetFolderURL(for: menu) else { return nil }

        let newMenu = NSMenu()
        let parentMenuItem = NSMenuItem(title: "New File", action: nil, keyEquivalent: "")
        let submenu = NSMenu()
        let activeTemplates = SharedTemplateStore.load().filter(\.isEnabled)

        if !activeTemplates.isEmpty {
            for (index, template) in activeTemplates.enumerated() {
                let item = NSMenuItem(title: template.title, action: #selector(createFileFromTemplate(_:)), keyEquivalent: "")
                item.tag = index
                item.target = self
                item.representedObject = targetFolder
                item.image = resolvedImage(for: template)
                submenu.addItem(item)
            }
        }

        parentMenuItem.submenu = submenu
        newMenu.addItem(parentMenuItem)
        newMenu.addItem(copyPathMenuItem(for: menu, fallbackURL: targetFolder))
        newMenu.addItem(terminalMenuItem(for: targetFolder))
        submenu.addItem(customizeMenuItem)

        return newMenu
    }

    func copyPathMenuItem(for menu: FIMenuKind, fallbackURL: URL) -> NSMenuItem {
        let item = NSMenuItem(title: "Copy Path", action: #selector(copyPath(_:)), keyEquivalent: "")
        item.target = self
        item.representedObject = copyTargetURLs(for: menu, fallbackURL: fallbackURL)

        return item
    }

    @objc func copyPath(_ sender: NSMenuItem) {
        let urls = copyTargetURLs(from: sender)
        guard !urls.isEmpty else {
            copyPathLogger.error("Copy Path could not resolve a Finder selection")
            NSApp.showException("Failed to get the selected file URL from FIFinderSyncController.")
            return NSLog("No file URL to copy")
        }

        let paths = urls
            .map(abbreviatedPath(for:))
            .joined(separator: "\n")

        // Finder Sync runs as a background-only process. Activation is
        // asynchronous, so let AppKit finish it before claiming the general
        // pasteboard on the next run-loop turn.
        NSApp.activate()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [copyPathLogger] in
            let pasteboard = NSPasteboard.general
            pasteboard.clearContents()

            guard pasteboard.setString(paths, forType: .string) else {
                copyPathLogger.error("Copy Path failed to write to the general pasteboard")
                NSApp.showException("Failed to copy the selected path to the clipboard.")
                return
            }

            copyPathLogger.notice("Copy Path wrote \(urls.count, privacy: .public) path(s) to the general pasteboard")
        }
    }

    @objc func createFileFromTemplate(_ sender: NSMenuItem) {
        guard let targetFolder = folderURL(from: sender) else {
            NSApp.showException("Failed to get the target URL from FIFinderSyncController, check FinderSync is enabled.")
            return NSLog("No target URL")
        }
        
        let activeTemplates = SharedTemplateStore.load().filter(\.isEnabled)
        guard activeTemplates.indices.contains(sender.tag) else {
            NSApp.showException("The selected template is no longer available.")
            return NSLog("Template index out of range")
        }
        
        let template = activeTemplates[sender.tag]

        let folderName = targetFolder.lastPathComponent
        let resolvedFileName = TemplateRenderer.resolvedFileName(for: template, folderName: folderName)
        let content = TemplateRenderer.resolvedContent(for: template, folderName: folderName)
        
        guard let fileURL = createFile(at: targetFolder, preferredName: resolvedFileName, content: content)
        else { return NSLog("No file created") }

        NSWorkspace.shared.selectFile(fileURL.path, inFileViewerRootedAtPath: "")
    }

    func terminalMenuItem(for targetFolder: URL) -> NSMenuItem {
        let item = NSMenuItem(title: "Terminal", action: #selector(openTerminalHere(_:)), keyEquivalent: "")
        item.image = NSImage(named: "TerminalIcon")
        item.toolTip = "Open Terminal in \(targetFolder.path)"
        item.target = self
        item.representedObject = targetFolder

        return item
    }

    var customizeMenuItem: NSMenuItem {
        let item = NSMenuItem(title: "Customize Templates…", action: #selector(openTemplateStudio), keyEquivalent: "")
        item.image = NSImage(named: "addAny")
        item.toolTip = "Open the template studio"
        item.target = self

        return item
    }

    func createFile(at directory: URL, preferredName: String, content: String) -> URL? {
        do {
            let fileURL = uniqueFileURL(in: directory, preferredName: preferredName)
            try content.write(to: fileURL, atomically: true, encoding: .utf8)
            
            return fileURL
        } catch {
            NSApp.showException(error.localizedDescription)
            NSLog("Error creating file: \(error.localizedDescription)")
            return nil
        }
    }

    @objc func openTerminalHere(_ sender: NSMenuItem) {
        guard let url = terminalFolderURL(from: sender) else {
            NSApp.showException("Failed to get the target URL from FIFinderSyncController, check FinderSync is enabled.")
            return NSLog("No target URL")
        }
        
        guard let terminalURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.apple.Terminal") else {
            NSApp.showException("Terminal.app could not be found.")
            return NSLog("Terminal.app could not be found")
        }
        
        let configuration = NSWorkspace.OpenConfiguration()
        NSWorkspace.shared.open([url], withApplicationAt: terminalURL, configuration: configuration) { _, error in
            if let error {
                NSLog("Failed to launch terminal: \(error.localizedDescription)")
                NSApp.showException(error.localizedDescription)
            }
        }
    }
    

    @objc func openTemplateStudio(_ sender: AnyObject?) {
        let extensionURL = Bundle.main.bundleURL
        // delete the extension path to get the app url
        let appURL = extensionURL
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        
        NSWorkspace.shared.openApplication(at: appURL, configuration: .init())
    }

    private func targetFolderURL(for menu: FIMenuKind) -> URL? {
        switch menu {
        case .contextualMenuForContainer:
            return directoryURL(from: FIFinderSyncController.default().targetedURL())
        case .contextualMenuForItems:
            return selectedContextFolderURL() ?? directoryURL(from: FIFinderSyncController.default().targetedURL())
        default:
            return nil
        }
    }

    private func folderURL(from sender: NSMenuItem) -> URL? {
        if let url = directoryURL(from: sender.representedObject as? URL) {
            return url
        }
        
        return directoryURL(from: FIFinderSyncController.default().targetedURL()) ?? selectedContextFolderURL()
    }
    
    private func terminalFolderURL(from sender: NSMenuItem) -> URL? {
        selectedContextFolderURL() ?? folderURL(from: sender)
    }

    private func copyTargetURLs(for menu: FIMenuKind, fallbackURL: URL) -> [URL] {
        if menu == .contextualMenuForItems,
           let selectedURLs = FIFinderSyncController.default().selectedItemURLs(),
           !selectedURLs.isEmpty {
            return selectedURLs
        }

        return [fallbackURL]
    }

    private func copyTargetURLs(from sender: NSMenuItem) -> [URL] {
        if let urls = sender.representedObject as? [URL], !urls.isEmpty {
            return urls
        }

        if let selectedURLs = FIFinderSyncController.default().selectedItemURLs(), !selectedURLs.isEmpty {
            return selectedURLs
        }

        if let targetedURL = FIFinderSyncController.default().targetedURL() {
            return [targetedURL]
        }

        return []
    }

    private func abbreviatedPath(for url: URL) -> String {
        let path = url.standardizedFileURL.path

        guard
            let passwordEntry = getpwuid(getuid()),
            let homeDirectory = passwordEntry.pointee.pw_dir
        else {
            return path
        }

        let homePath = String(cString: homeDirectory)
        guard path != homePath else { return "~" }

        let homePrefix = homePath.hasSuffix("/") ? homePath : homePath + "/"
        guard path.hasPrefix(homePrefix) else { return path }

        return "~/" + String(path.dropFirst(homePrefix.count))
    }

    private func selectedContextFolderURL() -> URL? {
        guard let selectedURL = FIFinderSyncController.default().selectedItemURLs()?.first else {
            return nil
        }

        if let directoryURL = directoryURL(from: selectedURL) {
            return directoryURL
        }
        
        guard FileManager.default.fileExists(atPath: selectedURL.path) else { return nil }
        return selectedURL.deletingLastPathComponent()
    }
    
    private func directoryURL(from url: URL?) -> URL? {
        guard let url else { return nil }
        
        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory), isDirectory.boolValue else {
            return nil
        }
        
        return url
    }

    
    private func uniqueFileURL(in directory: URL, preferredName: String) -> URL {
        let candidateURL = directory.appending(path: preferredName)

        guard FileManager.default.fileExists(atPath: candidateURL.path) else {
            return candidateURL
        }

        let preferredExtension = candidateURL.pathExtension
        let preferredBaseName = preferredExtension.isEmpty ? preferredName : candidateURL.deletingPathExtension().lastPathComponent
        var counter = 2

        while true {
            let numberedName = preferredExtension.isEmpty
                ? "\(preferredBaseName) \(counter)"
                : "\(preferredBaseName) \(counter).\(preferredExtension)"
            let numberedURL = directory.appending(path: numberedName)

            if !FileManager.default.fileExists(atPath: numberedURL.path) {
                return numberedURL
            }

            counter += 1
        }
    }

    private func resolvedImage(for template: TemplateDefinition) -> NSImage? {
        if let customIconRelativePath = template.customIconRelativePath,
           let url = SharedTemplateStore.customIconURL(for: customIconRelativePath),
           let image = NSImage(contentsOf: url) {
            return image
        }

        return NSImage(named: template.iconAssetName)
    }
}

extension NSApplication {
    func showException(_ localizedDescription: String) {
        let exception = NSException(name: .genericException, reason: localizedDescription, userInfo: nil)
        self.perform(Selector(("_showException:")), with: exception)
    }
}
