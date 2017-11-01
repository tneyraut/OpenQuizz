//
//  ViewControllerExtension.swift
//  OpenQuizz
//
//  Created by Thomas Mac on 31/10/2017.
//  Copyright © 2017 ThomasNeyraut. All rights reserved.
//

import UIKit

extension UIViewController
{
    func showModal(viewController: UIViewController)
    {
        let navigationController = UINavigationController(rootViewController: viewController)
        
        navigationController.navigationBar.barTintColor = AppColors.darkBlue
        
        navigationController.navigationBar.tintColor = UIColor.white
        
        navigationController.navigationBar.titleTextAttributes = NSDictionary(objects: [UIColor.white], forKeys: [NSForegroundColorAttributeName as NSCopying]) as? [String : AnyObject]
        
        viewController.addCancelButton()
        
        present(navigationController, animated: true, completion: nil)
    }
    
    func addCancelButton()
    {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: NSLocalizedString("SHARE_CANCEL", comment: ""),
            style: .done,
            target: self,
            action: #selector(closeModal))
    }
    
    func closeModal()
    {
        view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
