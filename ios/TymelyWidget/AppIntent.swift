//
//  AppIntent.swift
//  TymelyWidget
//
//  Created by Danny Chambers on 6/12/25.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Routine Widget Configuration" }
    static var description: IntentDescription { "Customize how your routine widget displays." }

    // Show upcoming items or only current
    @Parameter(title: "Show Upcoming Activities", default: true)
    var showUpcoming: Bool
    
    // Show completed items with reduced opacity
    @Parameter(title: "Show Completed Activities", default: false)
    var showCompleted: Bool
}
