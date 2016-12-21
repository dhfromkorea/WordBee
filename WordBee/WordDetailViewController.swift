//
//  WordDetailViewController.swift
//  WordBee
//
//  Created by dh on 10/21/16.
//  Copyright © 2016 dh. All rights reserved.
//

import UIKit

class WordDetailViewController: UIViewController, UITextFieldDelegate {
  var word: Word!
//  var isEditing = false

  @IBOutlet var headingLabels: [UILabel]!
  @IBOutlet weak var termLabel: UITextField!
  @IBOutlet weak var mnemonicLabel: UITextField!
  @IBOutlet weak var definitionTextView: UITextView!

  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()

    termLabel.text = word.term
    definitionTextView.text = word.definition
    mnemonicLabel.text = word.mnemonic


  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


  func configureView() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editWord))
    toggleEditing(isEditing: false)

    let headingAttributes = [
      NSKernAttributeName: 1,
      NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),
      NSForegroundColorAttributeName : UIColor.lightGray
    ] as [String : Any]

    headingLabels.forEach { $0.attributedText =
      NSAttributedString(string: $0.text!, attributes: headingAttributes)
    }

    let headingBodyAttributes = [
      NSKernAttributeName: 1,
      NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),
      NSForegroundColorAttributeName : UIColor.darkText
    ] as [String : Any]

    termLabel.attributedText = NSMutableAttributedString(string: word.term!, attributes: headingBodyAttributes)
    mnemonicLabel.attributedText = NSMutableAttributedString(string: word.mnemonic!, attributes: headingBodyAttributes)

    let bodyAttributes = [
      NSKernAttributeName: 1,
      NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body),
      NSForegroundColorAttributeName : UIColor.darkText
    ] as [String : Any]

    definitionTextView.attributedText = NSMutableAttributedString(string: word.definition!, attributes: bodyAttributes)

    // hideKeyboardWhenTappedAround()

  }

  func editWord() {
    if isEditing {
      toggleEditing(isEditing: false)
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editWord))
    } else {
      toggleEditing(isEditing: true)
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editWord))
    }
  }

  func toggleEditing(isEditing: Bool) {
    termLabel.isUserInteractionEnabled = isEditing
    mnemonicLabel.isUserInteractionEnabled = isEditing
    definitionTextView.isUserInteractionEnabled = isEditing
    self.isEditing = isEditing
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    // TODO: auto save
    print("auto saving... ")
  }


  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    termLabel.resignFirstResponder()
    mnemonicLabel.resignFirstResponder()
    definitionTextView.resignFirstResponder()
    return true
  }
}

extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    view.addGestureRecognizer(tap)
  }

  func dismissKeyboard() {
    view.endEditing(true)
  }
}
