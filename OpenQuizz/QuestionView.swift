//
//  QuestionView.swift
//  OpenQuizz
//
//  Created by Thomas Mac on 31/10/2017.
//  Copyright © 2017 ThomasNeyraut. All rights reserved.
//

import UIKit

class QuestionView: UIView
{
    @IBOutlet private var questionLabel: UILabel!
    @IBOutlet private var icon: UIImageView!
    
    var question = ""
    {
        didSet
        {
            questionLabel.text = question
        }
    }
    
    var style: StyleEnum = .standard
    {
        didSet
        {
            setStyle(style: style)
        }
    }
    
    private func setStyle(style: StyleEnum)
    {
        switch style
        {
            case .correct:
                icon.isHidden = false
                backgroundColor = AppColors.green
                icon.image = #imageLiteral(resourceName: "Icon Correct")
                break
            case .incorrect:
                icon.isHidden = false
                backgroundColor = AppColors.red
                icon.image = #imageLiteral(resourceName: "Icon Error")
                break
            default:
                icon.isHidden = true
                backgroundColor = AppColors.gray
                break
        }
    }
}
