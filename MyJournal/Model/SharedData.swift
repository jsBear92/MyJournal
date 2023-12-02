//
//  SharedData.swift
//  MyJournal
//
//  Created by Jaeseong Jeong on 2/12/2023.
//

import UIKit

class SharedData {
    // MARK: - Properties
    static let shard = SharedData()
    private var journalEntries: [JournalEntry]
    
    // MARK: - Private
    private init() {
        journalEntries = []
    }
    
    // MARK: - Access methods
    func numberOfJournalEntries() -> Int {
        journalEntries.count
    }
    func getJournalEntry(index: Int) -> JournalEntry {
        journalEntries[index]
    }
    func getAllJournalEntries() -> [JournalEntry] {
        let readOnlyJournalEntries = journalEntries
        return readOnlyJournalEntries
    }
    func addJournalEntry(newJournalEntry: JournalEntry) {
        journalEntries.append(newJournalEntry)
    }
    func removeJournalEntry(index: Int) {
        journalEntries.remove(at: index)
    }
}
