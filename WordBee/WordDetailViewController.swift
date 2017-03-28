//
//  WordDetailViewController.swift
//  WordBee
//
//  Created by dh on 10/21/16.
//  Copyright © 2016 dh. All rights reserved.
//

import UIKit
import CoreData
import NotificationCenter


class WordDetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
  var word: Word!
  var wordIndex: Int!
  var store: WordStore!

  @IBOutlet var headingLabels: [UILabel]!
  @IBOutlet weak var termLabel: UITextField!
  @IBOutlet weak var mnemonicLabel: UITextField!
  @IBOutlet weak var definitionTextView: UITextView!
  @IBOutlet weak var exampleTextView: UITextView!
  @IBOutlet weak var deleteButton: UIButton!

  @IBAction func deleteWord(_ sender: AnyObject) {

  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()

    termLabel.delegate = self
    termLabel.tag = 1

    mnemonicLabel.delegate = self
    mnemonicLabel.tag = 2

    definitionTextView.delegate = self
    definitionTextView.tag = 3

    exampleTextView.delegate = self
    exampleTextView.tag = 4
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
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

    let bodyAttributes = [
      NSKernAttributeName: 1,
      NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body),
      NSForegroundColorAttributeName : UIColor.darkText
      ] as [String : Any]

    termLabel.attributedText = NSMutableAttributedString(string: word.term, attributes: bodyAttributes)
    mnemonicLabel.attributedText = NSMutableAttributedString(string: word.mnemonic, attributes: bodyAttributes)

    definitionTextView.isScrollEnabled = false
    definitionTextView.textContainerInset = UIEdgeInsets.zero
    definitionTextView.textContainer.lineFragmentPadding = 0
    definitionTextView.attributedText = NSMutableAttributedString(string: word.definition ?? "no definition yet (you can modify this)", attributes: bodyAttributes)

    exampleTextView.isScrollEnabled = false
    exampleTextView.textContainerInset = UIEdgeInsets.zero
    exampleTextView.textContainer.lineFragmentPadding = 0
    exampleTextView.attributedText = NSMutableAttributedString(string: word.example ?? "no example yet (you can modify this)", attributes: bodyAttributes)
  }

  func editWord() {
    if isEditing {
      toggleEditing(isEditing: false)
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editWord))
    } else {
      toggleEditing(isEditing: true)
      deleteButton.isHidden = false
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editWord))
    }
  }

  func toggleEditing(isEditing: Bool) {
    termLabel.isUserInteractionEnabled = isEditing
    mnemonicLabel.isUserInteractionEnabled = isEditing
    definitionTextView.isUserInteractionEnabled = isEditing
    exampleTextView.isUserInteractionEnabled = isEditing

    self.isEditing = isEditing

  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    if let text = textField.text {
      switch textField.tag {
      case 1:
        word.term = text
      case 2:
        word.mnemonic = text
      case 3:
        word.definition = text
      case 4:
        word.example = text

      default:
        print("textfield ")
      }
    }
    store.saveWords()
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    if let text = textView.text {
      switch textView.tag {
      case 1:
        word.term = text
      case 2:
        word.mnemonic = text
      case 3:
        word.definition = text
      case 4:
        word.example = text

      default:
        print("textfield ")
      }
      store.saveWords()
    }
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    termLabel.resignFirstResponder()
    mnemonicLabel.resignFirstResponder()
    definitionTextView.resignFirstResponder()
    exampleTextView.resignFirstResponder()

    return true
  }

  func adjustForKeyboard(notification: Notification) {
    let userInfo = notification.userInfo!

    let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

    if notification.name == Notification.Name.UIKeyboardWillHide {
      definitionTextView.contentInset = UIEdgeInsets.zero
      exampleTextView.contentInset = UIEdgeInsets.zero
    } else {
      definitionTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
      exampleTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
    }

    definitionTextView.scrollIndicatorInsets = definitionTextView.contentInset
    exampleTextView.scrollIndicatorInsets = exampleTextView.contentInset

    definitionTextView.scrollRangeToVisible(definitionTextView.selectedRange)
    exampleTextView.scrollRangeToVisible(exampleTextView.selectedRange)
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
