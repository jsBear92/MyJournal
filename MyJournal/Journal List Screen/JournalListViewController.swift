//
//  ViewController.swift
//  MyJournal
//
//  Created by Jaeseong Jeong on 29/11/2023.
//

import UIKit

class JournalListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Properties
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SharedData.shard.numberOfJournalEntries()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let journalCell = tableView.dequeueReusableCell(withIdentifier: "journalCell", for: indexPath) as! JournalListTableViewCell
        let journalEntry = SharedData.shard.getJournalEntry(index: indexPath.row)
        journalCell.photoImageView.image = journalEntry.photo
        journalCell.dateLabel.text = journalEntry.date.formatted(.dateTime.day().month().year())
        journalCell.titleLabel.text = journalEntry.entryTitle
        return journalCell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            SharedData.shard.removeJournalEntry(index: indexPath.row)
            tableView.reloadData()
        }
    }
    
    
    
    // MARK: - Methods
    @IBAction func unwindNewEntryCancel(segue: UIStoryboardSegue) {
        
    }
    @IBAction func unwindNewEntrySave(segue: UIStoryboardSegue) {
        if let sourceViewController = segue.source as?
            AddJournalEntryViewController, let newJournalEntry =
            sourceViewController.newJournalEntry {
            SharedData.shard.addJournalEntry(newJournalEntry: newJournalEntry)
            tableView.reloadData()
        }
    }


}

