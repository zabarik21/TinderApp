//
//  Interestlabel.swift
//  TinderApp
//
//  Created by Timofey on 28/6/22.
//

import UIKit

class Interestlabel: UILabel {

    let padding = UIEdgeInsets(top: 8, left: 14, bottom: 8, right: 14)
  
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize : CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }

}
