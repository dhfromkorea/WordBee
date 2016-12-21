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

  @IBOutlet var headingLabels: [UILabel]!
  @IBOutlet weak var termLabel: UITextField!
  @IBOutlet weak var mnemonicLabel: UITextField!
  @IBOutlet weak var definitionTextView: UITextView!

  var sectionTitles = ["title", "termLabel"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()

    title = "edit: \(word.term)"
    termLabel.text = word.term
    definitionTextView.text = word.definition
    mnemonicLabel.text = word.mnemonic


  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

//  override func viewDidLayoutSubviews() {
//    termLabel.setBottomBorder(borderColor: UIColor.lightGray)
//    definitionLabel.setBottomBorder(borderColor: UIColor.lightGray)
//    mnemonicLabel.setBottomBorder(borderColor: UIColor.lightGray)
//  }

  func configureView() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editWord))

    let headingAttributes = [
      NSKernAttributeName: 1,
      NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),
      NSForegroundColorAttributeName : UIColor.lightGray
    ] as [String : Any]

    headingLabels.forEach { $0.attributedText =
      NSAttributedString(string: $0.text!, attributes: headingAttributes)
    }

    let title2Attributes = [
      NSKernAttributeName: 1,
      NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.title2),
      NSForegroundColorAttributeName : UIColor.darkText
    ] as [String : Any]

    termLabel.attributedText = NSMutableAttributedString(string: word.term, attributes: title2Attributes)
    mnemonicLabel.attributedText = NSMutableAttributedString(string: word.mnemonic, attributes: title2Attributes)

    let bodyAttributes = [
      NSKernAttributeName: 1,
      NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body),
      NSForegroundColorAttributeName : UIColor.darkText
    ] as [String : Any]

    definitionTextView.attributedText = NSMutableAttributedString(string: word.definition, attributes: bodyAttributes)

    hideKeyboardWhenTappedAround()

  }

  func editWord() {

  }
}

//extension UITextField {
//  func setBottomBorder(borderColor: UIColor) {
//    self.borderStyle = UITextBorderStyle.none
//    self.backgroundColor = UIColor.clear
//    let width = 1.0
//
//    let borderLine = UIView()
//    borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - width, width: Double(self.frame.width), height: width)
//    borderLine.backgroundColor = borderColor
//    self.addSubview(borderLine)
//  }
//}

extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    view.addGestureRecognizer(tap)
  }

  func dismissKeyboard() {
    view.endEditing(true)
  }
}
