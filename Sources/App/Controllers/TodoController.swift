import Fluent
import Vapor

//Todo Route
struct TodoController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let todos = routes.grouped("todos")
    todos.get(use: index)
    todos.post(use: create)
    todos.delete(":todoID", use: delete(req:))
    todos.post(":todoID", use: update(req:))
  }
  // read all todos
  func index(req: Request) throws -> EventLoopFuture<[Todo]> {
    return Todo.query(on: req.db).all()
  }
  /// create or update the todo
  func create(req: Request) throws -> EventLoopFuture<Todo> {
    let todo = try req.content.decode(Todo.self)
    return todo.save(on: req.db).map { todo }
  }
  /// update the todo
  func update(req: Request) throws -> EventLoopFuture<Todo> {
    let update = try req.content.decode(Todo.self)
    return Todo.find(req.parameters.get("todoID"), on: req.db).unwrap(or: Abort(.notFound)).flatMap { todo in
      todo.isCompleted = update.isCompleted
      todo.title = update.title
      return todo.save(on: req.db).map({update})
    }
  }
  /// delete the todo
  func delete(req: Request) throws -> EventLoopFuture<Todo> {
    return Todo.find(req.parameters.get("todoID"), on: req.db)
      .unwrap(or: Abort(.notFound))
      .flatMap { todo in
        todo.delete(on: req.db).map {todo} }
  }
}
