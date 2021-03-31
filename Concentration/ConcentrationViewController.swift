//
//  ViewController.swift
//  Concentration
//
//  Created by bogdanov on 18.03.21.
//

import UIKit

class ConcentrationViewController: VCLLoggingViewController {
    private lazy var game = Concentration(numberOfPairOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    var flipCount = 0 {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    override var vclLoggingName: String {
        return "ConcentrationView"
    }
    
    @IBOutlet private var flipCountLabel: UITextField! {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    @IBOutlet private var cardButtons: [UIButton]!

    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    @IBAction private func restartGame(_ sender: UIButton) {
        flipCount = 0
        emojiChoices = "🤡❤️✏️🌲🏡👩‍🎓🧑‍💻🏋️"
        game.resetCards(numberOfPairsOfCards)
        updateViewFromModel()
    }
    
    fileprivate func updateCardStyle(_ button: UIButton, _ card: Card) {
        button.setTitle(emoji(for: card), for: .normal)
        if card.isFaceUp {
            button.backgroundColor = UIColor.systemTeal
        } else {
            button.backgroundColor = UIColor.systemBlue
        }
    }
    
    fileprivate func flipOnCardChanged(_ button: UIButton, _ card: Card) {
        let newTitle = emoji(for: card)
        if button.currentTitle != nil, button.currentTitle != newTitle {
            UIView.transition(with: button,
                              duration: 0.6,
                              options: [.transitionFlipFromLeft],
                              animations: { [self] in
                                  updateCardStyle(button, card)
                              })
        } else {
            updateCardStyle(button, card)
        }
    }
    
    fileprivate func hideWithAnimation(_ button: UIButton) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.6,
                                                       delay: 0,
                                                       options: [],
                                                       animations: {
                                                           button.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
                                                       },
                                                       completion: { _ in
                                                           UIViewPropertyAnimator.runningPropertyAnimator(
                                                               withDuration: 0.6,
                                                               delay: 0,
                                                               options: [],
                                                               animations: {
                                                                   button.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                                                   button.alpha = 0
                                                               })
                                                       })
    }
    
    func updateViewFromModel() {
        if cardButtons != nil {
            for index in cardButtons.indices {
                let button = cardButtons[index]
                let card = game.cards[index]
                flipOnCardChanged(button, card)
                if card.isMatched {
                    hideWithAnimation(button)
                } else {
                    flipOnCardChanged(button, card)
                }
            }
        }
    }
    
    private var emojiChoices = "🤡❤️✏️🌲🏡👩‍🎓🧑‍💻🏋️"
    var theme: String? {
        didSet {
            emojiChoices = theme ?? ""
            emoji = [:]
            updateViewFromModel()
        }
    }
    
    private var emoji = [Card: String]()
    
    func emoji(for card: Card) -> String {
        if !card.isFaceUp {
            return ""
        }
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        
        return emoji[card] ?? "?"
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: 5.0,
            .strokeColor: UIColor.systemBlue
        ]
        let attributedString = NSAttributedString(string: "Flips \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
