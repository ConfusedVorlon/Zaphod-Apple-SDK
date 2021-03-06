//
//  UIViewController+Safari.swift
//  Off
//
//  Created by Rob Jonson on 28/03/2020.
//

#if !os(watchOS) && !os(tvOS) && canImport(UIKit)

import Foundation
import SafariServices

public extension UIViewController {

    @available(iOS 10.0, *)
    func openSafari(url: URL, tint: UIColor? = nil) {
        let vc = SFSafariViewController(url: url)

        vc.preferredBarTintColor = tint

        present(vc, animated: true)
    }

}

#endif
