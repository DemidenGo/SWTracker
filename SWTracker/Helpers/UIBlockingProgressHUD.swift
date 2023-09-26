//
//  UIBlockingProgressHUD.swift
//  SWTracker
//
//  Created by Юрий Демиденко on 13.08.2023.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {

    private static var window: UIWindow? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first
    }

    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }

    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}

