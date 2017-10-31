//
//  ViewExtension.swift
//  OpenQuizz
//
//  Created by Thomas Mac on 31/10/2017.
//  Copyright © 2017 ThomasNeyraut. All rights reserved.
//

import UIKit

extension UIView
{
    func setHiddenAnimated(hidden: Bool)
    {
        UIView.animate(
            withDuration: 0.8,
            delay: 0,
            options: .curveEaseOut,
            animations:
            {
                self.alpha = hidden ? 0 : 1
            },
            completion:
            { (success) in
                self.isHidden = hidden
            })
    }
}
