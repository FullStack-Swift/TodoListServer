# TodoListServer Online Docs

## Running Local with docker
```
#   Build images: docker-compose build
#      Start app: docker-compose up app
# Start database: docker-compose up db
# Run migrations: docker-compose run migrate
#       Stop all: docker-compose down (add -v to wipe db)
```

## HTTP Method
```
Method  CRUD
GET     Read
POST    Create
PUT     Replace
PATCH   Update
DELETE  Delete
```
## Web App
https://todolistappproj.herokuapp.com/webs/root

## Routing
https://todolistappproj.herokuapp.com
```
+--------+----------------+
| GET    | /todo-list     | websocket
+--------+----------------+
| GET    | /              | "index", ["title": "Hello TodoList!"
+--------+----------------+
| GET    | /hello         | "Hello, TodoList!"
+--------+----------------+
| GET    | /todos         | read [Todo]
+--------+----------------+
| POST   | /todos         | create or update Todo
+--------+----------------+
| PATCH  | /todos:/todoID | update Todo
+--------+----------------+
| POST   | /todos/:todoID | update Todo [Deprecated]
+--------+----------------+
| DELETE | /todos/:todoID | delete Todo
+--------+----------------+
```

## Todo Routes
```swift
struct TodoController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let todos = routes.grouped("todos")
    todos.get(use: index)
    todos.post(use: create)
    todos.delete(":todoID", use: delete(req:))
    todos.post(":todoID", use: update(req:))
    todos.patch(":todoID", use: update(req:))
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
    return Todo.find(req.parameters.get("todoID"), on: req.db)
      .unwrap(or: Abort(.notFound))
      .flatMap { todo in
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
```

## WebSocket
```swift
  websocketClients = WebsocketClients(eventLoop: app.eventLoopGroup.next())
  app.webSocket("todo-list") { request, webSocket in
    webSocket.send("Connected Socket", promise: request.eventLoop.makePromise())
    websocketClients.add(WebSocketClient(id: UUID(), socket: webSocket))
    webSocket.onText { ws, text in
      websocketClients.active.forEach { client in
        client.socket.send(text, promise: request.eventLoop.makePromise())
      }
    }
  }
```
