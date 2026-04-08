//
//  ContentView.swift
//  FinderFileCreator

import FinderSync
import SwiftUI


struct ContentView: View {
    @Environment(TemplateLibrary.self) private var library
    @State private var isTargeted = false

    var body: some View {
        HStack(spacing: 0) {
            SidebarView()
                .frame(width: 300)
            
            Rectangle()
                .fill(Color.black.opacity(0.08))
                .frame(width: 1)

            FileEditorView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .ignoresSafeArea()
        .animation(.snappy(duration: 0.2), value: isTargeted)
        .blur(radius: isTargeted ? 28 : 0)
        .overlay {
            if isTargeted {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()

                    VStack(spacing: 12) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 60))
                            .symbolRenderingMode(.hierarchical)
                        
                        Text("Drop file to create template")
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                    }
                }
            }
        }
        .dropDestination(for: URL.self) { items, _ in
            guard let firstURL = items.first else { return false }
            library.createTemplate(from: firstURL)
            return true
        } isTargeted: {
            isTargeted = $0
        }
    }
}


private struct SidebarView: View {
    @Environment(TemplateLibrary.self) private var library

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(.finderIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                
                Text("Finder File Creator").fontWeight(.semibold)
            }
            .padding(.horizontal, 14)
            .padding(.top, 35)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if !library.isExtensionEnabled {
                ExtensionDisabledCard()
                    .padding(.horizontal, 14)
                    .padding(.top, 10)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
            
            ScrollView {
                LazyVStack(spacing: 6) {
                    ForEach(library.templates) { template in
                        SidebarTemplateRow(
                            template: template,
                            isSelected: library.selectedTemplateID == template.id
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            library.selectedTemplateID = template.id
                        }
                        .onDrag { NSItemProvider(object: template.id.uuidString as NSString) }
                        .dropDestination(for: String.self) { items, location in
                            guard let draggedIdString = items.first,
                                  let draggedId = UUID(uuidString: draggedIdString) else { return false }
                            
                            library.moveTemplate(id: draggedId, to: template.id)
                            return true
                        }
                        .contextMenu {
                            Button("Duplicate") {
                                library.duplicateTemplate(id: template.id)
                            }

                            Button(template.isEnabled ? "Disable Template" : "Enable Template") {
                                library.toggleTemplateEnabled(id: template.id)
                            }

                            Divider()

                            Button("Delete") {
                                library.deleteTemplate(id: template.id)
                            }
                        }
                    }
                }
                .padding(.horizontal, 6)
                .padding(.top, 10)
            }
            .padding(.bottom, 16)

            Divider()
                .overlay(Color.black.opacity(0.08))

            HStack(spacing: 14) {
                Button("", systemImage: "plus", action: library.addNewTemplate)
                    .background(.white.opacity(0.001))
                    
                Button("", systemImage: "minus", action: library.deleteSelectedTemplate)
                    .background(.white.opacity(0.001))
                
                Spacer()
                
                Button(
                    "", systemImage: library.isExtensionEnabled ? "lock" : "lock.open",
                    action: FIFinderSyncController.showExtensionManagementInterface
                )
                .help("Extension is \(library.isExtensionEnabled ? "enabled" : "disabled")")
                    
                
                Button("", systemImage: "folder", action: revealTemplateStorage)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .pointerStyle(.link)
            .buttonStyle(.plain)
            .fontWeight(.medium)
            .labelStyle(.iconOnly)
            .foregroundStyle(.secondary)
        }
        .onAppear(perform: library.refreshExtensionStatus)
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { _ in
            library.refreshExtensionStatus()
        }
    }


    private func revealTemplateStorage() {
        let url = URL(fileURLWithPath: SharedTemplateStore.sharedGroupPath())
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }
}


private struct FileEditorView: View {
    @Environment(TemplateLibrary.self) private var library
    @State private var showingIconMenu = false

    var body: some View {
        Group {
            if let selectedTemplate = library.selectedTemplate {
                VStack(alignment: .leading, spacing: 0) {
                    topBar(for: selectedTemplate)
                        .padding(.horizontal, 22)
                        .padding(.top, 18)
                        .padding(.bottom, 12)

                    TextEditor(text: contentBinding)
                        .font(.system(size: 13, weight: .regular, design: .monospaced))
                        .scrollContentBackground(.hidden)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .foregroundStyle(.white)
                }
                .background(Color.black.secondary)
                .overlay(alignment: .bottom) {
                    TokenBarView()
                        .padding(.bottom, 24)
                }
            } else {
                Color.white.overlay(
                    Text("Select a template")
                        .foregroundStyle(.secondary)
                )
            }
        }
    }

    private func topBar(for template: TemplateDefinition) -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                TextField("Title", text: titleBinding)
                    .textFieldStyle(.plain)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
                TextField("filename.ext", text: fileNameBinding)
                    .textFieldStyle(.plain)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.secondary)
                    .foregroundStyle(.white)
            }

            Spacer(minLength: 16)

            HStack(spacing: 18) {
                IconToolbarButton(assetName: "PreviewAction") {
                    library.toggleTemplateEnabled(id: template.id)
                }
                .opacity(template.isEnabled ? 1 : 0.45)

                IconToolbarButton(assetName: "DocumentAction") {
                    library.duplicateTemplate(id: template.id)
                }

                Menu {
                    Button("Duplicate") {
                        library.duplicateTemplate(id: template.id)
                    }

                    Button(template.isEnabled ? "Disable" : "Enable") {
                        library.toggleTemplateEnabled(id: template.id)
                    }

                    Menu("Change Icon") {
                        ForEach(TemplateIconCatalog.all, id: \.self) { assetName in
                            Button(assetName) {
                                library.setTemplateIcon(id: template.id, assetName: assetName)
                            }
                        }
                    }

                    Divider()

                    Button("Delete", role: .destructive) {
                        library.deleteTemplate(id: template.id)
                    }
                } label: {
                    Image(systemName: "gearshape")
                }
                .menuStyle(.button)
                .fixedSize()
            }
            .padding(.top, 2)
        }
    }

    private var titleBinding: Binding<String> {
        Binding(
            get: { library.selectedTemplate?.title ?? "" },
            set: { newValue in
                library.updateSelectedTemplate { $0.title = newValue }
            }
        )
    }

    private var contentBinding: Binding<String> {
        Binding(
            get: { library.selectedTemplate?.content ?? "" },
            set: { newValue in
                library.updateSelectedTemplate { $0.content = newValue }
            }
        )
    }

    private var fileNameBinding: Binding<String> {
        Binding(
            get: {
                guard let template = library.selectedTemplate else { return "" }
                let ext = template.fileExtension.sanitizedExtension
                return ext.isEmpty ? template.defaultFileName : "\(template.defaultFileName).\(ext)"
            },
            set: { newValue in
                library.updateSelectedTemplate { template in
                    let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
                    let url = URL(fileURLWithPath: trimmed)
                    let ext = url.pathExtension
                    let base = url.deletingPathExtension().lastPathComponent

                    if ext.isEmpty {
                        template.defaultFileName = trimmed.nonEmpty ?? template.defaultFileName
                        template.fileExtension = ""
                    } else {
                        template.defaultFileName = base.nonEmpty ?? template.defaultFileName
                        template.fileExtension = ext
                    }
                }
            }
        )
    }
}


private struct SidebarTemplateRow: View {
    let template: TemplateDefinition
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 9) {
            Image("\(template.iconAssetName)")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)

            Text(template.title)
                .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                .lineLimit(1)
                .foregroundStyle(template.isEnabled ? Color.primary : Color.secondary)
            Spacer()
            
            if !template.isEnabled {
                Image(systemName: "eye.slash")
                    .symbolRenderingMode(.hierarchical)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(isSelected ? AnyShapeStyle(.quinary.opacity(0.8)) : AnyShapeStyle(Color.clear))
        )
    }
}


private struct IconToolbarButton: View {
    let assetName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(assetName)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 23, height: 23)
                .foregroundStyle(Color.white.opacity(0.58))
        }
        .buttonStyle(.plain)
        .pointerStyle(.link)
    }
}


private struct ExtensionDisabledCard: View {
    @Environment(TemplateLibrary.self) private var library

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Image(systemName: "xmark.seal.fill")
                .font(.system(size: 30, weight: .semibold))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.pink)

            Text("Turn on Finder File Creator in System Settings so your templates are available from Finder.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 10) {
                Button("Open Settings", action: FIFinderSyncController.showExtensionManagementInterface)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)

                Button("Refresh", action: library.refreshExtensionStatus)
                    .buttonStyle(.bordered)
                    .controlSize(.small)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(.quaternary, lineWidth: 0.8)
        }
    }
}
