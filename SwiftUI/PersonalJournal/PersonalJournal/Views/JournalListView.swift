//
//  ContentView.swift
//  PersonalJournal
//
//  Created by Ravi Shankar on 03/10/24.
//

import SwiftUI
import CoreData

struct JournalListView: View {
    @ObservedObject var viewModel: JournalViewModel
    @State var showAddEntryView: Bool = false
    
    var body: some View {
        NavigationView {
            List(viewModel.entries) { entry in
                NavigationLink(destination:JournalEntryView(entry: entry,
                                                            viewModel: viewModel)) {
                    VStack(alignment:.leading) {
                        Text(entry.title ?? "")
                            .font(.headline)
                        Text(entry.date ?? Date(), style: .date)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                                                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                                                Button(role: .destructive) {
                                                                    deleteEntry(entry: entry)
                                                                } label: {
                                                                    Label("Delete", systemImage: "trash")
                                                                }
                                                            }
            }
            .navigationTitle("Personal Journal")
            .navigationBarItems(trailing:
                                    Button(action: {
                showAddEntryView = true
            }) {
                Image(systemName: "plus")
            })
        }
        .sheet(isPresented: $showAddEntryView, content: {
            AddJournalView(viewModel: viewModel)
        })
    }
    
    func deleteEntry(entry: JournalEntry) {
        viewModel.deleteEntry(entry)
    }
}

#Preview {
    JournalListView(viewModel: JournalViewModel(viewContext: PersistenceController.preview.container.viewContext))
}
