//
//  HomeWidgetLiveActivity.swift
//  HomeWidget
//
//  Created by Min Min on 2023/06/18.
//

import ActivityKit
import WidgetKit
import SwiftUI

// iOS 16.1+
struct HomeWidgetAttributes: ActivityAttributes {
  public struct ContentState: Codable, Hashable {
    // Dynamic stateful properties about your activity go here!
    var value: Int
  }
  
  // Fixed non-changing properties about your activity go here!
  var name: String
}

struct HomeWidgetLiveActivity: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: HomeWidgetAttributes.self) { context in
      // Lock screen/banner UI goes here
      VStack {
        Text("Hello")
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
          Text("Bottom")
          // more content
        }
      } compactLeading: {
        Text("L")
      } compactTrailing: {
        Text("T")
      } minimal: {
        Text("Min")
      }
      .widgetURL(URL(string: "http://www.apple.com"))
      .keylineTint(Color.red)
    }
  }
}

struct HomeWidgetLiveActivity_Previews: PreviewProvider {
  static let attributes = HomeWidgetAttributes(name: "Me")
  static let contentState = HomeWidgetAttributes.ContentState(value: 3)
  
  static var previews: some View {
    // 상단 좌우로 작게 표시
    attributes
      .previewContext(contentState, viewKind: .dynamicIsland(.compact))
      .previewDisplayName("Island Compact")
    // 상단에 Compact보다 좀 더 큰 영역으로 표시
    attributes
      .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
      .previewDisplayName("Island Expanded")
    // Minimal : 우상단에 작게 표시
    attributes
      .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
      .previewDisplayName("Minimal")
    // 알림
    attributes
      .previewContext(contentState, viewKind: .content)
      .previewDisplayName("Notification")
  }
}
