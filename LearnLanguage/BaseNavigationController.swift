//
//  BaseNavigationController.swift
//  LearnLanguage
//
//  Created by iOS Student on 11/16/16.
//  Copyright © 2016 PIRATE. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        let navigationBarApperace = UINavigationBar.appearance()
        
        navigationBarApperace.barTintColor = UIColor(red: 119/255, green: 107/255, blue: 93/255, alpha: 1.0)
        navigationBarApperace.tintColor = UIColor.white
        
        navigationBarApperace.isTranslucent = false
        
        
    }

 
}
