//import HTMLKit
//import HTMLKitComponents
//
//  // MARK: Content
//struct RegisterContent: Codable {
//  var title: String
//}
//
//  // MARK: Page
//struct RegisterPage: Page {
//  private let content: [BodyElement]
//  private let title: String
//  
//  public init(title: String = "Register Page", @ContentBuilder<BodyElement> content: () -> [BodyElement]) {
//    self.title = title
//    self.content = content()
//  }
//  
//  public var body: AnyContent {
//    Document(type: .html5)
//    Html {
//      Head {
//        Title {
//          title
//        }
//      }
//      Body {
//        content
//      }
//    }
//  }
//}
//
//  // MARK: View
//struct RegisterView: View {
//  @TemplateValue(RegisterContent.self)
//  var context
//  
//  var body: AnyContent {
//    LoginPage(title: context.title.rawValue) {
//      List(direction: .vertical) {
//        ListRow {
//          TextField(name: "email") {
//            
//          }
//        }
//        ListRow {
//          SecureField(name: "password")
//        }
//        ListRow {
//          ActionButton(destination: "main") {
//            Text {
//              "Register"
//            }
//          }
//        }
//      }
//    }
//  }
//}
