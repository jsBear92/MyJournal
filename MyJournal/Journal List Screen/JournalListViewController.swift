//
//  ViewController.swift
//  MyJournal
//
//  Created by Jaeseong Jeong on 29/11/2023.
//

import UIKit

class JournalListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    // MARK: - Properties
    @IBOutlet var tableView: UITableView!
    let search = UISearchController(searchResultsController: nil)
    var filteredTableData: [JournalEntry] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        SharedData.shard.loadJournalEntriesData()
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search titles"
        navigationItem.searchController = search
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.search.isActive {
            return self.filteredTableData.count
        } else {
            return SharedData.shard.numberOfJournalEntries()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let journalCell = tableView.dequeueReusableCell(withIdentifier: "journalCell", for: indexPath) as! JournalListTableViewCell
        let journalEntry: JournalEntry
        if self.search.isActive {
            journalEntry = filteredTableData[indexPath.row]
        } else {
            journalEntry = SharedData.shard.getJournalEntry(index: indexPath.row)
        }
        if let photoData = journalEntry.photoData {
            journalCell.photoImageView.image = UIImage(data: photoData)
        }
        journalCell.dateLabel.text = journalEntry.dateString
        journalCell.titleLabel.text = journalEntry.entryTitle
        return journalCell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if self.search.isActive {
                let selectedJournalEntry = filteredTableData[indexPath.row]
                filteredTableData.remove(at: indexPath.row)
                SharedData.shard.removeSelectedJournalEntry(selectedJournalEntry)
            } else {
                SharedData.shard.removeJournalEntry(index: indexPath.row)
            }
            SharedData.shard.saveJournalEntriesData()
            tableView.reloadData()
        }
    }
    
    // MARK: - Search
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else { return }
        filteredTableData.removeAll()
        for journalEntry in SharedData.shard.getAllJournalEntries() {
            if journalEntry.entryTitle.lowercased().contains(
                searchBarText.lowercased()
            ) {
                filteredTableData.append(journalEntry)
            }
        }
        self.tableView.reloadData()
    }
    
    
    
    // MARK: - Methods
    @IBAction func unwindNewEntryCancel(segue: UIStoryboardSegue) {
        
    }
    @IBAction func unwindNewEntrySave(segue: UIStoryboardSegue) {
        if let sourceViewController = segue.source as?
            AddJournalEntryViewController, let newJournalEntry =
            sourceViewController.newJournalEntry {
            SharedData.shard.addJournalEntry(newJournalEntry: newJournalEntry)
            SharedData.shard.saveJournalEntriesData()
            tableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "entryDetail" else {
            return
        }
        guard let journalEntryDetailViewController = segue.destination as? JournalEntryDetailViewController, let selectedJournalEntryCell = sender as? JournalListTableViewCell, let indexPath = tableView.indexPath(for: selectedJournalEntryCell) else {
            fatalError("Could not get indexPath")
        }
        let selectedJournalEntry: JournalEntry
        if self.search.isActive {
            selectedJournalEntry = filteredTableData[indexPath.row]
        } else {
            selectedJournalEntry = SharedData.shard.getJournalEntry(index: indexPath.row)
        }
        journalEntryDetailViewController.selectedJournalEntry = selectedJournalEntry
    }
}
