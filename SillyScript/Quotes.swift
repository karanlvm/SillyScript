//  Quotes.swift
//  SillyScript
//
//  Created by Karan Vasudevamurthy on 9/18/25.
//

import Foundation

struct Quote: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let author: String?
}

enum QuoteStore {
    // Edit your quotes here
    static let all: [Quote] = [
        // — Upendra-style punchlines (inspired)
        Quote(text: "I am god, God is Great", author: "Upendra"),
        Quote(text: "Don't die trying, try dying", author: "Nayana"),
    ]

    static var random: Quote {
        all.randomElement() ?? Quote(text: "Add more quotes!", author: nil)
    }
}
