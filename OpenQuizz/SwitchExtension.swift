//
//  SwitchExtension.swift
//  OpenQuizz
//
//  Created by Thomas Mac on 01/11/2017.
//  Copyright © 2017 ThomasNeyraut. All rights reserved.
//

import UIKit

extension UISwitch
{
    func getStringValue() -> String
    {
        return isOn ? NSLocalizedString("SHARE_YES", comment: "") : NSLocalizedString("SHARE_NO", comment: "")
    }
}
