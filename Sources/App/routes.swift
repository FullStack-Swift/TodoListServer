import Fluent
import Vapor

func routes(_ app: Application) throws {
  app.get { req in
    return req.view.render("index", ["title": "Hello TodoList!"])
  }
  app.get("hello") { req -> String in
    return "Hello, TodoList!"
  }
  try app.register(collection: TodoController())
  try app.register(collection: WebController())
  
  print(app.routes.all) // [Route]
}
