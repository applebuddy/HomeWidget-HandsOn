//
//  ContentView.swift
//  HomeWidgetExample
//
//  Created by Min Min on 2023/06/18.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundColor(.accentColor)
      Text("Hello, world!")
      Button {
        // 모든 타겟 홈위젯을 업데이트 하거나, 일부 id의 widget만 업데이트 할 수 있어요.
        // WidgetCenter.shared.reloadAllTimelines()
        WidgetCenter.shared.reloadTimelines(ofKind: "HomeWidget")
      } label: {
        Text("Update Home Widget")
      }
      .frame(height: 30)

      Button {
        LiveActivityClient.shared.request()
      } label: {
        Text("Request Live Activity")
      }
      .frame(height: 30)

      Button {
        LiveActivityClient.shared.update(state: .init(value: Int.random(in: 0...10)))
      } label: {
        Text("Update Live Activity")
      }
      .frame(height: 30)

      Button {
        LiveActivityClient.shared.stop()
      } label: {
        Text("Stop Live Activity")
      }
      .frame(height: 30)
    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
