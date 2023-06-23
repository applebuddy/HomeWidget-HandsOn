//
//  HomeWidget.swift
//  HomeWidget
//
//  Created by Min Min on 2023/06/18.
//

import Intents
import WidgetKit
import SwiftUI

// https://api.sampleapis.com/coffee/hot
/// Sample Response
typealias CoffeeResponse = [Coffee]

struct Coffee: Decodable, Equatable {
  let title: String
  let description: String
}

struct MyActivity: Decodable {
  let activity: String
}

/// 위젯에 사용할 Sample API Client
final class APIClient {
  static var shared = APIClient()

  private func requestData<Model: Decodable>(urlRequest: URLRequest) async throws -> Model {
    let (data, _) = try await URLSession.shared.data(for: urlRequest)
    let jsonData = try JSONDecoder().decode(Model.self, from: data)
    return jsonData
  }

  func getCoffees() async throws -> CoffeeResponse {
    let url = URL(string: "https://api.sampleapis.com/coffee/hot")!
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "GET"
    return try await requestData(urlRequest: urlRequest)
  }

  func getMyActivity() async throws -> MyActivity {
    let url = URL(string: "https://www.boredapi.com/api/activity")!
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "GET"
    return try await requestData(urlRequest: urlRequest)
  }
}

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
    Task {
      do {
        let myActivity = try await APIClient.shared.getMyActivity()
        let entry = SimpleEntry(
          date: Date(),
          configuration: configuration,
          myActivity: myActivity
        )
        completion(entry)
      } catch {
        let entry = SimpleEntry(
          date: Date(),
          configuration: configuration,
          myActivity: nil
        )
        completion(entry)
      }
      // 위젯 추가 화면, 앱의 특정 시점에서 위젯을 업데이트 하고자 할때
    }
  }
  
  func getTimeline(
    for configuration: ConfigurationIntent,
    in context: Context,
    completion: @escaping (Timeline<Entry>) -> ()
  ) {
    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    // 업데이트 할 시점을 정의해서 주기적으로 홈화면의 위젯을 업데이트하고자 할때 사용
    /*
    var entries: [SimpleEntry] = []

    let currentDate = Date()
    for hourOffset in 0 ..< 5 {
      let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
      let entry = SimpleEntry(date: entryDate, configuration: configuration)
      entries.append(entry)
    }
    
    let timeline = Timeline(entries: entries, policy: .atEnd) // .atEnd, .never, .after
    */
    Task {
      do {
        let myActivity = try await APIClient.shared.getMyActivity()
        let entry = SimpleEntry(
          date: Date(),
          configuration: configuration,
          myActivity: myActivity
        )
        let nextDate = Calendar.current.date(bySetting: .minute, value: 3, of: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextDate))
        completion(timeline)
      } catch {
        let entry = SimpleEntry(
          date: Date(),
          configuration: configuration,
          myActivity: nil
        )
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
      }
    }
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let configuration: ConfigurationIntent
  var myActivity: MyActivity?
}

struct HomeWidgetEntryView : View {
  @Environment(\.widgetFamily) var family: WidgetFamily

  let entry: Provider.Entry

  init(entry: Provider.Entry) {
    self.entry = entry
  }
  
  var body: some View {
    switch family {
    case .systemSmall, .systemMedium, .systemLarge, .systemExtraLarge:
      mainView
    default:
      mainView
    }
  }

  var mainView: some View {
    VStack {
      Text(entry.date, style: .time)
      if let response = entry.myActivity {
        Text(response.activity)
          .font(.caption)
      }
    }
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
