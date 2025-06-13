//
//  TymelyWidget.swift
//  TymelyWidget
//
//  Created by Danny Chambers on 6/12/25.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), routineItem: WidgetSampleData.routineItems[5])
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration, routineItem: getCurrentRoutineItem())
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let currentDate = Date()
        let currentItem = getCurrentRoutineItem()
        
        // Create entry for now
        let currentEntry = SimpleEntry(date: currentDate, configuration: configuration, routineItem: currentItem)
        
        // Calculate next update time
        let nextUpdateDate = calculateNextUpdateTime(from: currentDate)
        
        return Timeline(entries: [currentEntry], policy: .after(nextUpdateDate))
    }
    
    private func getCurrentRoutineItem() -> WidgetRoutineItem {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let calendar = Calendar.current
        let now = Date()
        
        // Find the current or next upcoming item
        for item in WidgetSampleData.routineItems {
            if let itemTime = formatter.date(from: item.time) {
                // Create today's version of this time
                let todayItemTime = calendar.date(bySettingHour: calendar.component(.hour, from: itemTime),
                                                minute: calendar.component(.minute, from: itemTime),
                                                second: 0,
                                                of: now) ?? itemTime
                
                // If this item's time is in the future or current (within 30 minutes), this is our target
                if todayItemTime >= now.addingTimeInterval(-30 * 60) {
                    return item
                }
            }
        }
        
        // If all items are in the past, return the last item
        return WidgetSampleData.routineItems.last ?? WidgetSampleData.routineItems[0]
    }
    
    private func calculateNextUpdateTime(from currentDate: Date) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let calendar = Calendar.current
        
        // Find the next routine item time
        for item in WidgetSampleData.routineItems {
            if let itemTime = formatter.date(from: item.time) {
                let todayItemTime = calendar.date(bySettingHour: calendar.component(.hour, from: itemTime),
                                                minute: calendar.component(.minute, from: itemTime),
                                                second: 0,
                                                of: currentDate) ?? itemTime
                
                if todayItemTime > currentDate {
                    return todayItemTime
                }
            }
        }
        
        // If no future items today, update in 15 minutes
        return currentDate.addingTimeInterval(15 * 60)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let routineItem: WidgetRoutineItem
}

struct TymelyWidgetEntryView : View {
    var entry: Provider.Entry
    
    private var timeUntilNext: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let calendar = Calendar.current
        let now = Date()
        
        // Get the current item's time
        if let itemTime = formatter.date(from: entry.routineItem.time) {
            let todayItemTime = calendar.date(bySettingHour: calendar.component(.hour, from: itemTime),
                                            minute: calendar.component(.minute, from: itemTime),
                                            second: 0,
                                            of: now) ?? itemTime
            
            let timeInterval = todayItemTime.timeIntervalSince(now)
            
            if timeInterval > 0 {
                let minutes = Int(timeInterval / 60)
                if minutes < 60 {
                    return "In \(minutes)m"
                } else {
                    let hours = minutes / 60
                    let remainingMinutes = minutes % 60
                    if remainingMinutes == 0 {
                        return "In \(hours)h"
                    } else {
                        return "In \(hours)h \(remainingMinutes)m"
                    }
                }
            } else if timeInterval > -30 * 60 {
                return "Now"
            } else {
                return "Past"
            }
        }
        return ""
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header with time and status
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.routineItem.time)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(timeUntilNext)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(red: 1.0, green: 0.6, blue: 0.2))
                }
                
                Spacer()
                
                if let tag = entry.routineItem.tag {
                    Text(tag)
                        .font(.system(size: 10, weight: .bold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(entry.routineItem.tagColor.opacity(0.3))
                        .foregroundColor(entry.routineItem.tagColor)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            
            // Main content
            HStack(alignment: .top, spacing: 12) {
                // Icon
                Image(systemName: entry.routineItem.iconName)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                
                // Title and details
                VStack(alignment: .leading, spacing: 6) {
                    Text(entry.routineItem.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(2)
                    
                    if !entry.routineItem.details.isEmpty {
                        Text(entry.routineItem.details.first ?? "")
                            .font(.system(size: 12))
                            .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                            .lineLimit(2)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
            
            Spacer()
            
            // Bottom accent line
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 1.0, green: 0.8, blue: 0.0),   // Yellow
                            Color(red: 1.0, green: 0.6, blue: 0.2),   // Orange
                            Color(red: 1.0, green: 0.4, blue: 0.6),   // Pink
                            Color(red: 0.2, green: 0.6, blue: 1.0),   // Blue
                            Color(red: 0.6, green: 0.4, blue: 1.0)    // Purple
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 3)
        }
        .containerBackground(for: .widget) {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.05), // Very dark gray
                    Color(red: 0.02, green: 0.02, blue: 0.02)  // Almost black
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

struct TymelyWidget: Widget {
    let kind: String = "TymelyWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            TymelyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Current Activity")
        .description("Shows your current routine activity.")
        .supportedFamilies([.systemMedium])
    }
}

extension ConfigurationAppIntent {
    fileprivate static var defaultConfig: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.showUpcoming = true
        return intent
    }
}

#Preview(as: .systemMedium) {
    TymelyWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .defaultConfig, routineItem: WidgetSampleData.routineItems[5])
    SimpleEntry(date: .now, configuration: .defaultConfig, routineItem: WidgetSampleData.routineItems[10])
}
