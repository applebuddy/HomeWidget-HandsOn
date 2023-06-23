
# iOS HomeWidget Hands On

- 예전에는 today extension widget이 있었습니다. 아이폰 맨 좌측 페이지 하단에 편집 버튼을 누르면 사용자화 버튼이 나오고 여기에서 today extension 위젯을 사용할 수 있었어요. 하지만 이 위젯의 단점은 지정된 위치에서만 추가를 해서 사용이 가능하다는 점이었습니다.
- 이어서 나온 것이 iOS14 버전 이상에서 지원하는 홈위젯 기능이었습니다.
  - 이 위젯의 큰 차이점이라면 홈 화면 어디에든 드래그해서 추가하고, 편집하고 사용자화를 할 수 있습니다. 
  - 또한 스마트 스택으로 하나의 영역에 다양한 위젯을 담아서 페이징 하면서 볼 수도 있고, 스택 내의 위젯을 자유롭게 편집할 수 있습니다.
- iOS14부터 지원하는 홈위젯은 SwiftUI로만 개발이 가능하고, small, medium, large (iPad의 경우 extra large)의 다양한 크기로 개발을 할 수 있습니다. 또한 타임라인 개념을 통해서 주기적으로 위젯 업데이트를 하거나, 앱의 특정 시점에서 위젯의 업데이트 요청을 할 수 있습니다. 이후 iOS16.1 부터는 추가적으로 Live Activity 라는 위젯 기능을 개발할 수 있습니다.

### iOS 프로젝트 생성 및 홈위젯 타겟 생성방법

- 이제 홈위젯 샘플을 생성하는 과정을 보겠습니다. 먼저 command+shift+N을 통해서 일반적인 iOS앱 프로젝트를 생성해주세요. 이때 기본 홈위젯 개발을 위해서는 iOS14, Live Activity 기능을 Preview 기능과 함께 구현하기 위해서는 최소 iOS16.2로 설정해 주셔야 합니다.
- 이후에 이어서 위젯을 위한 타겟을 추가해줘야 합니다. 좌상단 File클릭, New에 Target을 클릭합니다. iOS 섹션의 Widget Extension을 검색해서 선택합니다. 본인이 iOS 16.2 이상의 최소타겟이라면 Live Activity도 개발하고 싶다면 추가하시면 되고, 위젯 편집기능을 구현하고 싶다면 Configuration Intent 체크박스도 활성화 하시면 됩니다.
- 그렇게 기본 위젯 파일이 생성됩니다. 그리고, 위젯 파일의 PreviewProvider코드가 있는 화면을 가서 option+command+enter를 하시면, 현재 날짜가 표시되는 샘플 위젯에 대한 preview를 확인이 가능합니다. 앞서 말씀드린것처럼 위젯은 대, 중, 소, 아이패드의 경우 extraLarge까지 다양한 크기 별로 개발이 가능한데요. 따라서 이와 같이 큰 화면의 위젯도 프리뷰를 보면서 개발할 수 있습니다.

### 홈위젯 구성 및 업데이트 해보기

- 이제 생성한 기본 홈위젯 구성을 보겠습니다. 크게 Widget, EntryView, Provider, SimpleEntry 입니다.
  - 실제 코드 보며 얘기해요.
  - Widget, EntryView, Provider, SimpleEntry의 각 역할
  - APIClient를 통해, API 요청 후, 응답을 위젯에 업데이트 하는 방법
  - 앱에서 위젯을 직접 업데이트 하는 방법
  - 앱 타겟으로 디버깅 시, 홈 위젯을 함께 디버깅 하는 방법
  - 홈위젯의 제약사항
    - 실시간 업데이트가 되지 않음
    - 버튼을 누를때 반드시 앱으로 들어가는 사양



### iOS 16.1+ Live Activity

- iPhone 14 pro 이상 부터 지원이 되는 가능
- Live Activity를 지원하는 앱 설정 -> 실시간 현황 권한을 설정 가능

- Widget Target을 생성할때 Live Activity 옵션을 함께 추가하여 사용 가능합니다.
- ActivityKit(16.1+)을 import 한 뒤, ActivityAttributes에서 실시간으로 제공할 정보, 고정형 정보를 나누어서 정의가능합니다.
  - Live Activity의 Preview context를 통해 Preview 사용을 하려면 16.2+ 이 되어야 합니다.
  - iOS14부터 지원하는 홈위젯은 실시간 업데이트가 되지 않는 단점이 있었는데요. Live Activity Widget은 최대 8 ~ 12시간 동안 앱의 실시간 정보를 제공할 수 있는 장점이 있습니다.
  - ActivityKit을 통해 앱에서 동적데이터를 업데이트할 수 있습니다.
- IntentConfiguration 대신 ActivityConfiguration을 사용해서 LiveActivity Widget을 만듭니다. 
  - 첫 레이블 인자로 ActivityAttributes 타입을 지정 하고, 그 다음 content 인자에 락스크린에 표출할 UI를 정의합니다.
  - 그 다음 dynamic Island 에 다양한 형태의 LiveActivity Widget을 정의할 수 있습니다. 
    - minimal, compact, expanded, notification
  - LiveActivity 의 Preview를 사용하기 위해서는 iOS 16.2 버전 이상의 환경이 필요합니다.



### Live Activity 구성 및 업데이트 해보기

- 실제 코드 보며 얘기해요.



### 홈위젯 만들때 주의사항

- 앞서 말씀드렸지만, 홈위젯의 버튼 액션은 홈화면에서 바로 동작하지 않습니다.
  - 구 위젯과 달리, 무조건 앱으로 진입 후 동작을 해야하는 것이 시스템 사양입니다.
- iOS 14 이상 타겟으로 생겼던 홈 위젯은 실시간, 실시간으로 업데이트 되지 않아요. 이부분은 애플 자체적으로 관리를 하는 부분이 있습니다.
  - reference : https://developer.apple.com/documentation/widgetkit/keeping-a-widget-up-to-date
  - 앱의 특정 시점에 업데이트를 실행할 수는 있지만, 주기적인 업데이트는 홈위젯의 사용주기 등을 고려해서 시스템에서 업데이트를 합니다.
    - 홈위젯 우상단에 최근 업데이트 시점이나, 업데이트가 된지 얼마나 지났는지 시간 정보를 제공하는 방법이 있습니다.
