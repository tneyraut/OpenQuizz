//
//  RoundedButton.swift
//  OpenQuizz
//
//  Created by Thomas Mac on 31/10/2017.
//  Copyright © 2017 ThomasNeyraut. All rights reserved.
//

import UIKit

class RoundedButton: UIButton
{
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        layer.borderWidth = 1
        layer.cornerRadius = 23
        
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowColor = AppColors.darkBlue.cgColor
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.8
    }
}
