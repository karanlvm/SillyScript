// SillyScriptWidget.swift
import WidgetKit
import SwiftUI

// MARK: - Timeline Entry
struct QuoteEntry: TimelineEntry {
    let date: Date
    let quote: Quote
}

// MARK: - Provider
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> QuoteEntry {
        QuoteEntry(date: Date(), quote: Quote(text: "Loading…", author: nil))
    }

    func getSnapshot(in context: Context, completion: @escaping (QuoteEntry) -> Void) {
        completion(QuoteEntry(date: Date(), quote: QuoteStore.random))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<QuoteEntry>) -> Void) {
        let now = Date()
        let refreshInterval: TimeInterval = 15 * 60 // 15 minutes
        let horizon = 6 // 1.5 hours of entries

        var entries: [QuoteEntry] = []
        for i in 0..<horizon {
            let when = now.addingTimeInterval(Double(i) * refreshInterval)
            entries.append(QuoteEntry(date: when, quote: QuoteStore.random))
        }

        completion(Timeline(
            entries: entries,
            policy: .after(now.addingTimeInterval(Double(horizon) * refreshInterval))
        ))
    }
}

// MARK: - Entry View
struct QuoteWidgetEntryView: View {
    @Environment(\.widgetFamily) private var family
    let entry: QuoteEntry

    @ViewBuilder
    private var content: some View {
        switch family {
        case .accessoryInline:
            Text(entry.quote.text)
                .lineLimit(1)

        case .accessoryCircular:
            // Keep super minimal for circular. No custom solid background.
            if let author = entry.quote.author, let initial = author.first {
                Text(String(initial)).font(.headline)
            } else {
                Text("“”").font(.headline)
            }

        case .accessoryRectangular:
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.quote.text)
                    .font(.system(size: 12))
                    .lineLimit(2)
                if let author = entry.quote.author {
                    Text("— \(author)")
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }

        case .systemSmall:
            VStack(alignment: .leading, spacing: 6) {
                Text("Quote")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(entry.quote.text)
                    .font(.callout)
                    .lineLimit(4)
                if let author = entry.quote.author {
                    Text("— \(author)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            .padding()

        default:
            Text(entry.quote.text)
        }
    }

    var body: some View {
        if #available(iOS 17.0, *) {
            content
                .containerBackground(.fill.tertiary, for: .widget)
        } else {
            content
        }
    }
}

// MARK: - Widget
@main
struct SillyScriptWidget: Widget {
    let kind: String = "SillyScriptWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            QuoteWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("QuoteLock")
        .description("Shows a random hard-coded quote.")
        .supportedFamilies([
            .accessoryInline,
            .accessoryCircular,
            .accessoryRectangular,
            .systemSmall
        ])
    }
}

// MARK: - Previews (iOS 16 style)
struct SillyScriptWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            QuoteWidgetEntryView(entry: QuoteEntry(date: Date(), quote: Quote(text: "Preview quote", author: "Preview")))
                .previewContext(WidgetPreviewContext(family: .systemSmall))

            QuoteWidgetEntryView(entry: QuoteEntry(date: Date(), quote: Quote(text: "Inline preview", author: nil)))
                .previewContext(WidgetPreviewContext(family: .accessoryInline))

            QuoteWidgetEntryView(entry: QuoteEntry(date: Date(), quote: Quote(text: "Rectangular preview with author", author: "Ada")))
                .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
        }
    }
}
