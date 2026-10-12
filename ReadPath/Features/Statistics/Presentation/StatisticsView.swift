//
//  StatisticsView.swift
//  ReadPath
//
//  Created by Егор on 12.10.2026.
//

import SwiftUI

struct StatisticsView: View {
    let statisticsViewModel: StatisticsViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Total:")
                Spacer()
                Text("\(statisticsViewModel.totalBooksCount)")
            }
            .font(.headline)
            Divider()
            HStack {
                Text("Want to read:")
                Spacer()
                Text("\(statisticsViewModel.wantToReadBooksCount)")
                    .font(.headline)
            }
            HStack {
                Text("Reading:")
                Spacer()
                Text("\(statisticsViewModel.readingBooksCount)")
                    .font(.headline)
            }
            HStack {
                Text("Completed:")
                Spacer()
                Text("\(statisticsViewModel.completedBooksCount)")
                    .font(.headline)
            }
            
            if let errorMassage = statisticsViewModel.errorMassage {
                Text(errorMassage)
                    .foregroundStyle(.red)
                
                Button("Refresh") {
                    statisticsViewModel.refreshStatistics()
                }
            }
        }
        .padding()
        .onAppear {
            statisticsViewModel.refreshStatistics()
        }
    }
}
