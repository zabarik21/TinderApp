//
//  CardViewContainer.swift
//  TinderApp
//
//  Created by Timofey on 30/5/22.
//

import UIKit

protocol CardContainerViewProtocol {
    
    var backCardData: Data { get set }
    var frontCardData: Data { get set }
    
    var topCardView: CardViewProtocol { get }
    var backCardView: CardViewProtocol { get }
    var backCardContainer: UIView { get }
    
}

class CardContainerView: UIView, CardContainerViewProtocol {
    
    
    
    
    var backCardData: Data
    
    var frontCardData: Data
    
    var backCardContainer: UIView
    
    var backCardView: UIView
    var topCardView: UIView = UIView()
    
    var delegate: CardContainerDelagate?
    
//    private var currentUserCard: UserCard
//    private var nextUserCard: UserCard
    
    // has 2 properties that updates every time card swipe
    // properties are initing in init
    
    // at the init
    // setup top & bottom card
    
    // after swipe
    // removing top card from superview
    // back card animating to top
    // configuring new back card
    
    // when top card is swiped
    // top card is removing from view
    // bottom card animates to top
    // and new bottom card is configuring
    
    
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .blue
        self.backCardData = Data()
        self.frontCardData = Data()
        backCardContainer = UIView()
    }
    
    private func swiped() {
        topCardView.removeFromSuperview()
        let card = CardView(CardContainerDelagate.?nextUser())
        topCardView = backCardView
        showNew()
        backCardContainer.addSubview(card)
    }
    
    private func showNew() {
        UIView.animate(withDuration: 0.5) {
            // top anchor up to 5
            // left and right up to 12
             // bottom up to 11
        }
    }
    
    private func setupCards(_ front: Data, _ second: Data) {
        let frontCardView = CardView(front)
        let bottomCardView = CardView(bottom)
        frontCardView = currentCard
        backCardContainer.addSubview(bottomCardView)
        backCardContainer.addSubview(frontCardView)
        
        UIView.animate(withDuration: 0.5) {
            NSLayoutConstraint.activate([
               // top anchor up to 5
               // left and right up to 12
                // bottom up to 11
            ]])
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
