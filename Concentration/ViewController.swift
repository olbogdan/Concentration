//
//  ViewController.swift
//  Concentration
//
//  Created by bogdanov on 18.03.21.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips \(flipCount)"
        }
    }
    
    @IBOutlet var flipCountLabel: UITextField!
    
    fileprivate func flipCard(withEmoji emoji: String, on button: UIButton) {
        flipCount += 1
        
        if button.currentTitle == emoji {
            button.setTitle(nil, for: UIControl.State.normal)
            button.backgroundColor = UIColor.orange
        } else {
            button.setTitle(emoji, for: UIControl.State.normal)
            button.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        flipCard(withEmoji: "🤡", on: sender)
    }
    
    @IBAction func touchCard2(_ sender: UIButton) {
        flipCard(withEmoji: "❤️", on: sender)
    }
}
