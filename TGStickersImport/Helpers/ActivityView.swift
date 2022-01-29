//
//  ActivityView.swift
//  TGStickersImport
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import SwiftUI
import LinkPresentation
import CoreServices

struct ActivityView: UIViewControllerRepresentable {

    private var activityItems: Binding<[Any]>
    private let applicationActivities: [UIActivity]?
    private let completion: UIActivityViewController.CompletionWithItemsHandler?

    @Binding var isPresented: Bool

    init(isPresented: Binding<Bool>, items: Binding<[Any]>, activities: [UIActivity]? = nil, onComplete: UIActivityViewController.CompletionWithItemsHandler? = nil) {
        _isPresented = isPresented
        activityItems = items
        applicationActivities = activities
        completion = onComplete
    }

    func makeUIViewController(context: Context) -> ActivityViewControllerWrapper {
        ActivityViewControllerWrapper(isPresented: $isPresented, activityItems: activityItems, applicationActivities: applicationActivities, onComplete: completion)
    }

    func updateUIViewController(_ uiViewController: ActivityViewControllerWrapper, context: Context) {
        uiViewController.isPresented = $isPresented
        uiViewController.completion = completion
        uiViewController.activityItems = activityItems
        uiViewController.updateState()
    }

}

final class ActivityViewControllerWrapper: UIViewController {

    var activityItems: Binding<[Any]>
    var applicationActivities: [UIActivity]?
    var isPresented: Binding<Bool>
    var completion: UIActivityViewController.CompletionWithItemsHandler?

    init(isPresented: Binding<Bool>, activityItems: Binding<[Any]>, applicationActivities: [UIActivity]? = nil, onComplete: UIActivityViewController.CompletionWithItemsHandler? = nil) {
        self.activityItems = activityItems
        self.applicationActivities = applicationActivities
        self.isPresented = isPresented
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        updateState()
    }

    fileprivate func updateState() {
        let isActivityPresented = presentedViewController != nil

        if isActivityPresented != isPresented.wrappedValue {
            if !isActivityPresented {
                let controller = UIActivityViewController(activityItems: activityItems.wrappedValue, applicationActivities: applicationActivities)
                controller.popoverPresentationController?.sourceView = view
                controller.completionWithItemsHandler = { [weak self] (activityType, success, items, error) in
                    self?.isPresented.wrappedValue = false
                    self?.completion?(activityType, success, items, error)
                }
                present(controller, animated: true, completion: nil)
            }
        }
    }

}
