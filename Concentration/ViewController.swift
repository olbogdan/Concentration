//
//  ViewController.swift
//  Concentration
//
//  Created by bogdanov on 18.03.21.
//

import UIKit

class ViewController: UIViewController {
    private lazy var game = Concentration(numberOfPairOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    var flipCount = 0 {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    @IBOutlet private var flipCountLabel: UITextField! {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    // MARK: Handle Card Touch Behavior

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
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = UIColor.white
            } else {
                button.setTitle(nil, for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? nil : UIColor.orange
            }
        }
    }
    
    private var emojiChoices = "🤡❤️✏️🌲🏡👩‍🎓🧑‍💻🏋️"
    
    private var emoji = [Card: String]()
    
    func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        
        return emoji[card] ?? "?"
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: 5.0,
            .strokeColor: UIColor.yellow
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
