//
//  WordDetailViewController.swift
//  WordBee
//
//  Created by dh on 10/21/16.
//  Copyright © 2016 dh. All rights reserved.
//

import UIKit

class WordDetailViewController: UIViewController {
  var word: Word!

  @IBOutlet var termLabel: UITextField!
  @IBOutlet var definitionLabel: UITextField!
  @IBOutlet var mnemonicLabel: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "edit: \(word.term)"
    termLabel.text = word.term
    definitionLabel.text = word.definition
    mnemonicLabel.text = word.mnemonic
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
