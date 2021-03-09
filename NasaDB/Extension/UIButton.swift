//
//  UIButton.swift
//  NasaDB
//
//  Created by admin on 9.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import UIKit

extension UIButton {
    func getCurvyButton(_ button: UIButton) {
        button.layer.cornerRadius = button.frame.size.height / 2
    }
}
