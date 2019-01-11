//
//  UIPageViewControllerWithOverlayIndicator.swift
//  Lend It
//
//  Created by Daniel Esteban Salinas Suárez on 1/11/19.
//  Copyright © 2019 Daniel Esteban Salinas Suárez. All rights reserved.
//

import UIKit

class UIPageViewControllerWithOverlayIndicator: UIPageViewController {
    override func viewDidLayoutSubviews() {
        for subView in self.view.subviews {
            if subView is UIScrollView {
                subView.frame = self.view.bounds
            } else if subView is UIPageControl {
                self.view.bringSubviewToFront(subView)
            }
        }
        super.viewDidLayoutSubviews()
    }
}
