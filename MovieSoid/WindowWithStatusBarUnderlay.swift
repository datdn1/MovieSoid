//
//  WindowWithStatusBarUnderlay.swift
//  MovieSoid
//
//  Created by datdn1 on 6/16/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import Foundation
import UIKit

class WindowWithStatusBarUnderlay: UIWindow {

    private let statusBarOpaqueUnderlayView: UIView!

    override init(frame: CGRect) {
        self.statusBarOpaqueUnderlayView = UIView()
        self.statusBarOpaqueUnderlayView.backgroundColor = .clear
        super.init(frame: frame)
        self.addSubview(self.statusBarOpaqueUnderlayView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.bringSubview(toFront: self.statusBarOpaqueUnderlayView)
        var statusBarFrame = CGRect.zero
        statusBarFrame.size.width = UIScreen.main.bounds.size.width
        statusBarFrame.size.height = UIApplication.shared.statusBarFrame.size.height
        self.statusBarOpaqueUnderlayView.frame = statusBarFrame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
