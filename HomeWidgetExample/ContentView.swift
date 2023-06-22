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
        // 모든 홈위젯을 업데이트 하거나, 일부 id의 widget만 업데이트 할 수 있어요.
        // WidgetCenter.shared.reloadAllTimelines()
        WidgetCenter.shared.reloadTimelines(ofKind: "HomeWidget")
      } label: {
        Text("Update Widget~~!!")
      }
    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
