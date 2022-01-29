//
//  WrapUIKitView.swift
//  TGStickersImport
//
//  Created by Starkov Dmitry on 01/07/2021.
//

import SwiftUI

struct UIKitViewControllerExtensible<Controller: UIViewController>: UIViewControllerRepresentable {
    typealias UIViewControllerType = Controller
    
    var controller: Controller
 
    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> UIViewControllerType {
        controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<Self>) { }
}

extension UIViewController {
    func toSwiftUI() -> AnyView {
        return AnyView(UIKitViewControllerExtensible(controller: self))
    }
}
