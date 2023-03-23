//
//  UIImageView+Extension.swift
//  WeatherApp
//
//  Created by tamu on 23/03/23.
//

import Kingfisher
import UIKit

extension UIImageView {
    func setImage(_ url: String, placeholder: String? = "") {
        self.kf.setImage(with: URL(string: url), placeholder: UIImage(named: placeholder ?? ""))
    }
}
