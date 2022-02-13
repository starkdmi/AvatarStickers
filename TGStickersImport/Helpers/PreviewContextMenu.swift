//
//  PreviewContextMenu.swift
//  TGStickersImport
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import SwiftUI

struct PreviewContextMenu<Destination: View, Preview: View> {
    let destination: Destination
    let preview: Preview
    let previewSize: CGSize?
    let actionProvider: UIContextMenuActionProvider?
    
    init(destination: Destination, preview: Preview, size: CGSize? = nil, actionProvider: UIContextMenuActionProvider? = nil) {
        self.destination = destination
        self.preview = preview
        self.previewSize = size
        self.actionProvider = actionProvider
    }
}

struct PreviewContextView<Destination: View, Preview: View>: UIViewRepresentable {
    
    let menu: PreviewContextMenu<Destination, Preview>
    let onCommit: () -> Void
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.backgroundColor = UIColor.clear.cgColor
        let menuInteraction = UIContextMenuInteraction(delegate: context.coordinator)
        view.addInteraction(menuInteraction)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(menu: self.menu, onCommit: self.onCommit)
    }
    
    class Coordinator: NSObject, UIContextMenuInteractionDelegate {
        
        let menu: PreviewContextMenu<Destination, Preview>
        let onCommit: () -> Void
        
        init(menu: PreviewContextMenu<Destination, Preview>, onCommit: @escaping () -> Void) {
            self.menu = menu
            self.onCommit = onCommit
        }
        
        func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
            return UIContextMenuConfiguration(identifier: nil, previewProvider: { () -> UIViewController? in
                let controller = UIHostingController(rootView: self.menu.preview)
                if let contentSize = self.menu.previewSize {
                    controller.preferredContentSize = contentSize
                }
                return controller
            }, actionProvider: self.menu.actionProvider)
        }
                
        func contextMenuInteraction(_ interaction: UIContextMenuInteraction, previewForHighlightingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
            guard let view = interaction.view else { return nil }
            
            let parameters = UIPreviewParameters()
            parameters.backgroundColor = .clear
            parameters.visiblePath = UIBezierPath(ovalIn: view.bounds)

            return UITargetedPreview(view: view, parameters: parameters)
        }
        
        func contextMenuInteraction(_ interaction: UIContextMenuInteraction, previewForDismissingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
            guard let view = interaction.view, self.menu.actionProvider == nil else { return nil }
            
            let parameters = UIPreviewParameters()
            parameters.backgroundColor = .clear
            parameters.visiblePath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 0, height: 0))
            
            return UITargetedPreview(view: view, parameters: parameters)
        }
        
        func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
            self.onCommit()
        }
    }
}

struct PreviewContextViewModifier<D: View, P: View>: ViewModifier {
    let menu: PreviewContextMenu<D, P>
    @State var isFullScreen: Bool = false
        
    func body(content: Content) -> some View {
        ZStack {
            NavigationLink("", destination: menu.destination, isActive: $isFullScreen).hidden()
                        
            content.overlay(PreviewContextView(menu: menu, onCommit: {
                self.isFullScreen.toggle()
            }))
        }
    }
}

extension View {
    func contextMenu<Destination: View, Preview: View>(_ menu: PreviewContextMenu<Destination, Preview>) -> some View {
        self.modifier(PreviewContextViewModifier(menu: menu))
    }
}
