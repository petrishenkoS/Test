//
//  TableViewCell.swift
//  Test
//
//  Created by Admin on 14.04.16.
//  Copyright © 2016 Serhii Petrishenko. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func registerNibName(name: String) {
        self.registerNib(UINib(nibName: name.stringByReplacingOccurrencesOfString("Test.", withString: ""), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: name)
    }
    
    func registerNibNames(names: [String]) {
        for name in names {
            registerNibName(name)
        }
    }
    
}
