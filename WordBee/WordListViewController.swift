//
//  ViewController.swift
//  WordBee
//
//  Created by dh on 10/21/16.
//  Copyright © 2016 dh. All rights reserved.
//

import UIKit

class WordListViewController: UITableViewController {
  var words = [Word]()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    configureView()
    loadData()
  }


  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return words.count
  }


  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "WordCell", for: indexPath) as? WordTableViewCell else {
      // TODO: clean this up
      return WordTableViewCell()
    }
    let word = words[indexPath.row]

    cell.mnemonicLabel?.textColor = UIColor.lightGray
    cell.mnemonicLabel?.text = word.mnemonic

    cell.wordLabel?.text = word.term

    return cell
  }


  @IBAction func hintTapped(_ sender: AnyObject) {
    print("hint tapped")
    let word = words[sender.tag]
    print("hint button found with \(word.mnemonic)")
  }


  // MARK: configure views
  func configureView() {
    navigationItem.rightBarButtonItem =
      UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWord))
    // navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Modes", style: .plain, target: self, action: #selector(changeMode))

    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 80
  }


  func loadData() {
    let defaults = UserDefaults.standard
    if let wordsData = defaults.object(forKey: "words") as? Data,
      let savedWords = NSKeyedUnarchiver.unarchiveObject(with: wordsData) as? [Word] {
      words = savedWords
    }
  }


  // MARK: CRUD funcs for Words
  func addWord() {
    let ac = UIAlertController(title: "add a new word", message: nil, preferredStyle: .alert)
    ac.addTextField { (textField : UITextField!) in
      textField.placeholder = "word"
    }
    ac.addTextField { (textField : UITextField!) in
      textField.placeholder = "definition"
    }
    ac.addTextField { (textField : UITextField!) in
      textField.placeholder = "hint (one word)"
    }

    let saveAction = UIAlertAction(title: "save", style: .default) { [unowned self, ac ] _ in
      if let word = ac.textFields?[0].text, !word.isEmpty,
        let definition = ac.textFields?[1].text, !definition.isEmpty,
        let hint = ac.textFields?[2].text, !hint.isEmpty {
          let word = Word(word: word, definition: definition, hint: hint)
          self.words.append(word)
          self.tableView.reloadData()
          self.saveWordsData()
      }
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

    ac.addAction(saveAction)
    ac.addAction(cancelAction)
    present(ac, animated: true)
  }


  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == "WordDetailViewSegue" else { return }
    guard let vc = segue.destination as? WordDetailViewController,
      let row = tableView.indexPathForSelectedRow?.row else { return }
    vc.word = words[row]
  }


  func saveWordsData() {
    let data = NSKeyedArchiver.archivedData(withRootObject: words)
    let defaults = UserDefaults.standard
    defaults.set(data, forKey: "words")
  }
  
}
