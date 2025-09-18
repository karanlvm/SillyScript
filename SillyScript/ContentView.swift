//
//  ContentView.swift
//  SillyScript
//
//  Created by Karan Vasudevamurthy on 9/18/25.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @State private var lastRefresh = Date()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("QuoteLock")
                    .font(.largeTitle.bold())

                Text("This app feeds a Lock Screen widget with a random hard-coded quote.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Button {
                    // Ask WidgetKit to reload our timelines
                    WidgetCenter.shared.reloadAllTimelines()
                    lastRefresh = Date()
                } label: {
                    Text("Refresh Widget Now")
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .background(Color.blue.opacity(0.15))
                        .clipShape(Capsule())
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("How to add the Lock Screen widget:")
                        .font(.headline)
                    Text("1. Build to a physical device (⌘R).")
                    Text("2. Lock your iPhone, tap & hold the Lock Screen, then tap **Customize**.")
                    Text("3. Tap the widget area under the clock, search for **QuoteLock**, and add a size.")
                    Text("4. Exit customize. The quote will update every ~15 minutes or when you tap Refresh.")
                }
                .padding()
                .background(.thinMaterial)
                .cornerRadius(12)

                Text("Last refresh: \(lastRefresh.formatted(date: .abbreviated, time: .standard))")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                Spacer()
            }
            .padding()
            .navigationTitle("Home")
        }
    }
}
