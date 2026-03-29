//
//  FinderSync.swift
//  Extension

import Cocoa
import FinderSync


class FinderSync: FIFinderSync {
    override init() {
        super.init()

        let rootURL = URL(fileURLWithPath: "/")
        FIFinderSyncController.default().directoryURLs = Set([rootURL])

        NSLog("FinderSync initialized")
        NSLog("Monitoring root directory for global coverage")
    }

    override func menu(for menu: FIMenuKind) -> NSMenu? {
        guard menu == .contextualMenuForContainer else { return nil }

        let newMenu = NSMenu()
        let parentMenuItem = NSMenuItem(title: "New File", action: nil, keyEquivalent: "")
        let submenu = NSMenu()
        let activeTemplates = SharedTemplateStore.load().filter(\.isEnabled)

        if !activeTemplates.isEmpty {
            for (index, template) in activeTemplates.enumerated() {
                let item = NSMenuItem(title: template.title, action: #selector(createFileFromTemplate(_:)), keyEquivalent: "")
                item.tag = index
                item.target = self
                item.image = NSImage(named: template.iconAssetName)
                submenu.addItem(item)
            }
        }

        parentMenuItem.submenu = submenu
        newMenu.addItem(parentMenuItem)
        newMenu.addItem(terminalMenuItem)
        submenu.addItem(customizeMenuItem)

        return newMenu
    }

    @objc func createFileFromTemplate(_ sender: NSMenuItem) {
        guard let targetFolder = FIFinderSyncController.default().targetedURL() else {
            NSApp.showException("Failed to get the target URL from FIFinderSyncController, check FinderSync is enabled.")
            return NSLog("No target URL")
        }
        
        let activeTemplates = SharedTemplateStore.load().filter(\.isEnabled)
        let template = activeTemplates[sender.tag]

        let folderName = targetFolder.lastPathComponent
        let resolvedFileName = TemplateRenderer.resolvedFileName(for: template, folderName: folderName)
        let content = TemplateRenderer.resolvedContent(for: template, folderName: folderName)
        
        guard let fileURL = createFile(at: targetFolder, preferredName: resolvedFileName, content: content)
        else { return NSLog("No file created") }

        NSWorkspace.shared.selectFile(fileURL.path, inFileViewerRootedAtPath: "")
    }

    var terminalMenuItem: NSMenuItem {
        let item = NSMenuItem(title: "Terminal", action: #selector(openCurrentDicInTerminal), keyEquivalent: "")
        item.image = NSImage(named: "TerminalIcon")
        item.toolTip = "Open Terminal in current directory"
        item.target = self

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

    @objc func openCurrentDicInTerminal(_ sender: AnyObject?) {
        guard let url = FIFinderSyncController.default().targetedURL() else { return }

        let task = Process()
        task.currentDirectoryURL = url
        task.executableURL = URL(fileURLWithPath: "/usr/bin/open")
        task.arguments = ["-a", "Terminal", url.path]

        do {
            try task.run()
        } catch {
            NSLog("Failed to launch terminal: \(error.localizedDescription)")
            NSApp.showException(error.localizedDescription)
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

    
    private func uniqueFileURL(in directory: URL, preferredName: String) -> URL {
        let candidateURL = directory.appending(path: preferredName)

        guard FileManager.default.fileExists(atPath: candidateURL.path) else {
            return candidateURL
        }

        let preferredExtension = candidateURL.pathExtension
        var counter = 2

        while true {
            let numberedName = preferredExtension.isEmpty
                ? "\(preferredName) \(counter)"
                : "\(preferredName) \(counter).\(preferredExtension)"
            let numberedURL = directory.appending(path: numberedName)

            if !FileManager.default.fileExists(atPath: numberedURL.path) {
                return numberedURL
            }

            counter += 1
        }
    }
}

extension NSApplication {
    func showException(_ localizedDescription: String) {
        let exception = NSException(name: .genericException, reason: localizedDescription, userInfo: nil)
        self.perform(Selector(("_showException:")), with: exception)
    }
}
