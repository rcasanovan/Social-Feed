//
//  SFFont.swift
//  Social Feed
//
//  Created by Ricardo Casanova on 05/08/2017.
//  Copyright © 2017 Social Feed. All rights reserved.
//

import Foundation

extension UIFont {
    func sizeOfString (string: String, constrainedToWidth width: Double) -> CGSize {
        return (string as NSString).boundingRect(with: CGSize(width: width, height: Double.greatestFiniteMagnitude),
                                                         options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                         attributes: [NSFontAttributeName: self],
                                                         context: nil).size
    }
}
