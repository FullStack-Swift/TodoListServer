import HTMLKit
import HTMLKitComponents
import CryptoKit

  // MARK: Content
struct MainContent: Codable {
  var title: String
  var todos: [Task]
  var totalTasks: String {
    "\(todos.count) + Todos"
  }
}

struct Task: Codable {
  var id: String?
  var title: String
  var isCompleted: Bool
}

extension Todo {
  func asTask() -> Task {
    Task(id: id?.uuidString, title: title, isCompleted: isCompleted)
  }
}

extension Array where Element == Todo {
  func asTasks() -> [Task] {
    self.map {
      $0.asTask()
    }
  }
}
  // MARK: Page
struct MainPage: Page {
  private let content: [BodyElement]
  private let title: String
  
  init(title: String = "Main Page",@ContentBuilder<BodyElement> content: () -> [BodyElement]) {
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
struct MainView: View {
  @TemplateValue(MainContent.self)
  var context
  
  var body: AnyContent {
    MainPage(title: context.title.rawValue) {
      Heading1 {
        Text {
          context.totalTasks
        }
        ForEach(enumerated: context.todos) { value, index in
          HStack(alignment: .baseline) {
            IF(value.isCompleted) {
              ImageView(source: "http://127.0.0.1:8080/check.png")
            }
            IF(!value.isCompleted) {
              ImageView(source: "http://127.0.0.1:8080/uncheck.png")
            }
            Text {
              value.title
            }
          }
          .backgroundColor(.red)
        }
      }
    }
  }
}
