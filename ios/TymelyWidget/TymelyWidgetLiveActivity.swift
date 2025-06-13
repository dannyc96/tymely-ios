//
//  TymelyWidgetLiveActivity.swift
//  TymelyWidget
//
//  Created by Danny Chambers on 6/12/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TymelyWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct TymelyWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TymelyWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension TymelyWidgetAttributes {
    fileprivate static var preview: TymelyWidgetAttributes {
        TymelyWidgetAttributes(name: "World")
    }
}

extension TymelyWidgetAttributes.ContentState {
    fileprivate static var smiley: TymelyWidgetAttributes.ContentState {
        TymelyWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: TymelyWidgetAttributes.ContentState {
         TymelyWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: TymelyWidgetAttributes.preview) {
   TymelyWidgetLiveActivity()
} contentStates: {
    TymelyWidgetAttributes.ContentState.smiley
    TymelyWidgetAttributes.ContentState.starEyes
}
