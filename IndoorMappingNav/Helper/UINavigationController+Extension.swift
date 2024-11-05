//
//  UINavigationController+Extension.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 05/11/24.
//

import Foundation
import UIKit
extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
