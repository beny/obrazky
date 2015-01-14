//
//  DarkNavigationController.swift
//  Obrazky
//
//  Created by Ondra Benes on 14/01/15.
//  Copyright (c) 2015 OB. All rights reserved.
//

import UIKit

class DarkNavigationController: UINavigationController {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .BlackTranslucent
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barStyle = .Default
    }

}
