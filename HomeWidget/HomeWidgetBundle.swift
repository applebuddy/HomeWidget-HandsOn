//
//  HomeWidgetBundle.swift
//  HomeWidget
//
//  Created by Min Min on 2023/06/18.
//

import WidgetKit
import SwiftUI

// 생성한 위젯의 메인
// 일반 홈 위젯만 사용한다면, Widget만 준수하면 되나, LiveActivity까지 사용하고 싶다면 단일 위젯 내에 다수의 Widget을 사용할 수 있게 하는 Bundle protocol을 채택하여 사용
@main
struct HomeWidgetBundle: WidgetBundle {
  var body: some Widget {
    HomeWidget()
    HomeWidgetLiveActivity()
  }
}

