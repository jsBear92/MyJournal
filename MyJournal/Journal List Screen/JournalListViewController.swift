//
//  ViewController.swift
//  MyJournal
//
//  Created by Jaeseong Jeong on 29/11/2023.
//

import UIKit

class JournalListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchResultsUpdating {
    // MARK: - Properties
    @IBOutlet var collectionView: UICollectionView!
    let search = UISearchController(searchResultsController: nil)
    var filteredTableData: [JournalEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SharedData.shard.loadJournalEntriesData()
        setupCollectionView()
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search titles"
        navigationItem.searchController = search
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.search.isActive {
            return self.filteredTableData.count
        } else {
            return SharedData.shard.numberOfJournalEntries()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let journalCell = collectionView.dequeueReusableCell(withReuseIdentifier: "journalCell", for: indexPath) as! JournalListCollectionViewCell
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
    
    // MARK: - UICollectionView delete method
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) {
            (elements) -> UIMenu? in
            let delete = UIAction(title: "Delete") { (action) in
                if self.search.isActive {
                    let selectedJournalEntry = self.filteredTableData[indexPath.item]
                    self.filteredTableData.remove(at: indexPath.item)
                    SharedData.shard.removeSelectedJournalEntry(selectedJournalEntry)
                } else {
                    SharedData.shard.removeJournalEntry(index: indexPath.item)
                }
                SharedData.shard.saveJournalEntriesData()
                self.collectionView.reloadData()
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: [], children: [delete])
        }
        return config
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
        self.collectionView.reloadData()
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
            collectionView.reloadData()
        }
    }
    
    // MARK: - Setup Collection View
    func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 10
        collectionView.collectionViewLayout = flowLayout
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var columns: CGFloat
        if (traitCollection.horizontalSizeClass == .compact) {
            columns = 1
        } else {
            columns = 2
        }
        let viewWidth = collectionView.frame.width
        let inset = 10.0
        let contentWidth = viewWidth - inset * (columns + 1)
        let cellWidth = contentWidth / columns
        let cellHeight = 90.0
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "entryDetail" else {
            return
        }
        guard let journalEntryDetailViewController = segue.destination as? JournalEntryDetailViewController, let selectedJournalEntryCell = sender as? JournalListCollectionViewCell, let indexPath = collectionView.indexPath(for: selectedJournalEntryCell) else {
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
