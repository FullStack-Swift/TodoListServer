import HTMLKit
import HTMLKitComponents

  // MARK: Content
struct RootContent: Codable {
  var title: String
}
  // MARK: Page
struct RootPage: Page {
  private let content: [BodyElement]
  private let title: String
  
  init(title: String = "Root Page",@ContentBuilder<BodyElement> content: () -> [BodyElement]) {
    self.title = title
    self.content = content()
  }
  
  var body: AnyContent {
    Document(type: .html5)
    Html {
      Head {
        Title {
          title
        }
      }
      Body {
        content
      }
    }
  }
}

  // MARK: View
struct RootView: View {
  @TemplateValue(RootContent.self)
  var context
  
  var body: AnyContent {
    LoginPage(title: context.title.rawValue) {
      VStack(alignment: .center) {
        HStack(alignment: .center) {
          Text {
            "TodoList"
          }
          .foregroundColor(.red)
          .underline()
          ActionButton(destination: "login") {
            Text {
              "Login"
            }
          }
          ActionButton(destination: "register") {
            Text {
              "Register"
            }
          }
        }
      }
    }
  }
}
