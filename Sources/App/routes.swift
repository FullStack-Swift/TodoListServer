import Fluent
import Vapor

func routes(_ app: Application) throws {

  app.get { req async throws in
    try await req.view.render("index", ["title": "Hello TodoList!"])
  }

  app.get("hello") { req async -> String in
    "Hello, TodoList!"
  }

  try app.register(collection: TodoController())
  //  try app.register(collection: WebController())
  
  print(app.routes.all) // [Route]
}
