//
//  StringExtension.swift
//  OpenQuizz
//
//  Created by Thomas Mac on 30/10/2017.
//  Copyright © 2017 ThomasNeyraut. All rights reserved.
//

import UIKit

extension String
{
    init?(htmlEncodedString: String)
    {
        guard let data = htmlEncodedString.data(using: .utf8)
            else
        {
            return nil
        }
        
        let options = [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue] as [String : Any]
        
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil)
            else
        {
            return nil
        }
        
        self.init(attributedString.string)
    }
}
