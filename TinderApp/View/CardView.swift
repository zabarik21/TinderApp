//
//  CardView.swift
//  TinderApp
//
//  Created by Timofey on 30/5/22.
//

import UIKit



class CardView: UIView {

    // Main idea
    // CardView is given to card containerView
    // Card container is empty by default
    // when new card is given to cardContainer -> start animation (bringing card to the top)
    // self view is not touchable ()
    // card container must have delegate
    // that tells a container that the top card is left and new card needed to be shown
    // or just by updating some container property in viewController
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
