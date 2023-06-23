//
//  LiveActivityClient.swift
//  HomeWidgetExample
//
//  Created by Min Min on 2023/06/24.
//

import ActivityKit
import SwiftUI

final class LiveActivityClient: ObservableObject {
  static let shared = LiveActivityClient()

  @Published var activity: Activity<HomeWidgetAttributes>?

  private init() {}

  /// ContentState 초기 설정
  func request() {
    guard activity == nil else { return }

    let attributes = HomeWidgetAttributes(name: "HomeWidget")
    let contentState = HomeWidgetAttributes.ContentState(value: 3)

    do {
      let activity = try Activity<HomeWidgetAttributes>.request(
        attributes: attributes,
        content: .init(
          state: contentState,
          staleDate: nil
        )
      )

      self.activity = activity
      print(activity)
    } catch {
      print(error)
    }
  }

  /// ContentState 상태 업데이트
  func update(state: HomeWidgetAttributes.ContentState) {
    guard let activity else { return }
    Task {
      let newContentState = HomeWidgetAttributes.ContentState(value: state.value)
      await activity.update(
        .init(
          state: newContentState,
          staleDate: nil
        )
      )
    }
  }

  /// 살아있는 ContentState 종료
  func stop() {
    guard let activity else { return }

    Task { @MainActor [weak self] in
      await activity.end(activity.content, dismissalPolicy: .immediate)
      self?.activity = nil
    }
  }
}
