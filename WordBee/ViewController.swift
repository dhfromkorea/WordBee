//
//  ViewController.swift
//  WordBee
//
//  Created by dh on 10/21/16.
//  Copyright © 2016 dh. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var words = [Word]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWord))
        
        let defaults = UserDefaults.standard
        if let wordsData = defaults.object(forKey: "words") as? Data {
            words = NSKeyedUnarchiver.unarchiveObject(with: wordsData) as! [Word]
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        let word = words[indexPath.row]
        cell.textLabel!.text = word.term
        cell.detailTextLabel!.text = word.definition
        return cell
    }
    
    func addWord() {
        let ac = UIAlertController(title: "add a new word", message: nil, preferredStyle: .alert)
        ac.addTextField { (textField : UITextField!) in
            textField.placeholder = "word"
        }
        ac.addTextField { (textField : UITextField!) in
            textField.placeholder = "definition"
        }
        let saveAction = UIAlertAction(title: "save", style: .default) { [unowned self, ac ] _ in
            if let term = ac.textFields?[0].text,
               let definition = ac.textFields?[1].text {
                let word = Word(term, definition: definition)
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
        guard segue.identifier == "WordDetailView" else { return }
        guard let vc = segue.destination as? WordDetailViewController else { return }
        
        if let row = tableView.indexPathForSelectedRow?.row {
            let word = words[row]
            vc.word = word
        }
    }
    
    func saveWordsData() {
        let data = NSKeyedArchiver.archivedData(withRootObject: words)
        let defaults = UserDefaults.standard
        defaults.set(data, forKey: "words")
    }
}
