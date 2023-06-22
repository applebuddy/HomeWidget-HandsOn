//
//  HomeWidget.swift
//  HomeWidget
//
//  Created by Min Min on 2023/06/18.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    // 위젯 default 화면 지정
    SimpleEntry(date: Date(), configuration: ConfigurationIntent())
  }
  
  func getSnapshot(
    for configuration: ConfigurationIntent,
    in context: Context,
    completion: @escaping (SimpleEntry) -> ()
  ) {
    // 위젯 추가 화면, 앱의 특정 시점에서 위젯을 업데이트 하고자 할때
    let entry = SimpleEntry(date: Date(), configuration: configuration)
    completion(entry)
  }
  
  func getTimeline(
    for configuration: ConfigurationIntent,
    in context: Context,
    completion: @escaping (Timeline<Entry>) -> ()
  ) {
    var entries: [SimpleEntry] = []
    
    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    // 업데이트 할 시점을 정의해서 주기적으로 홈화면의 위젯을 업데이트하고자 할때 사용
    let currentDate = Date()
    for hourOffset in 0 ..< 5 {
      let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
      let entry = SimpleEntry(date: entryDate, configuration: configuration)
      entries.append(entry)
    }
    
    let timeline = Timeline(entries: entries, policy: .atEnd) // .atEnd, .never, .after
    completion(timeline)
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let configuration: ConfigurationIntent
}

struct HomeWidgetEntryView : View {
  var entry: Provider.Entry
  
  var body: some View {
    Text(entry.date, style: .time)
  }
}

struct HomeWidget: Widget {
  let kind: String = "HomeWidget"
  
  var body: some WidgetConfiguration {
    IntentConfiguration(
        kind: kind, // widget identifier
        intent: ConfigurationIntent.self, // user configuration
        provider: Provider(), // placeholder, snapshot, timeline 설정 등
        content: HomeWidgetEntryView.init // 실제 위젯에 표출될 View
    )
    .configurationDisplayName("My Widget") // 위젯 추가화면 타이틀
    .description("This is an example widget.") // 위젯 추가화면 description
  }
}

struct HomeWidget_Previews: PreviewProvider {
  static var previews: some View {
    HomeWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
      .previewContext(WidgetPreviewContext(family: .systemLarge))
  }
}
