//
//  KeyboardObserver.swift
//  TGStickersImport
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import Foundation
import Combine

class KeyboardObserver: ObservableObject {
    @Published private(set) var keyboardHeight: CGFloat = 0
    
    let keyboardWillShow = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillShowNotification)
        .compactMap { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height }
    
    let keyboardWillHide = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillHideNotification)
        .map { _ -> CGFloat in 0 }
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
      Publishers.Merge(keyboardWillShow, keyboardWillHide)
        .subscribe(on: RunLoop.main)
        .assign(to: \.keyboardHeight, on: self)
        .store(in: &cancellables)
    }
}
