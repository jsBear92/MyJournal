//
//  JournalEntryDetailViewcontroller.swift
//  MyJournal
//
//  Created by Jaeseong Jeong on 2/12/2023.
//

import UIKit

class JournalEntryDetailViewcontroller: UITableViewController {

    // MARK: - Properties
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bodyTextView: UITextView!
    @IBOutlet var photoImageView: UIImageView!
    var sampleJournalEntryData = SampleJournalEntryData()
    var selectedJournalEntry: JournalEntry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.text = selectedJournalEntry?.date.formatted(
            .dateTime.day().month(.wide).year()
        )
        titleLabel.text = selectedJournalEntry?.entryTitle
        bodyTextView.text = selectedJournalEntry?.entryBody
        photoImageView.image = selectedJournalEntry?.photo
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "entryDetail" else {
            return
        }
        guard let journalEntryDetailViewController = segue.destination as? JournalEntryDetailViewcontroller, let selectedJournalEntryCell = sender as? JournalListTableViewCell, let indexPath = tableView.indexPath(for: selectedJournalEntryCell) else {
            fatalError("Could not get indexPath")
        }
        let selectedJournalEntry = sampleJournalEntryData.journalEntries[indexPath.row]
        journalEntryDetailViewController.selectedJournalEntry = selectedJournalEntry
    }
}
