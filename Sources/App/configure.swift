import Fluent
import FluentPostgresDriver
import Leaf
import Vapor
import Foundation

  // cache websocket
var websocketClients: WebsocketClients!
  // configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
  
    // configuarion database
  if let databaseURL = Environment.get("DATABASE_URL"), var postgresConfig = PostgresConfiguration(url: databaseURL) {
    postgresConfig.tlsConfiguration = .makeClientConfiguration()
    postgresConfig.tlsConfiguration?.certificateVerification = .none
    app.databases.use(.postgres(
      configuration: postgresConfig
    ), as: .psql)
  } else {
    app.databases.use(.postgres(
      hostname: Environment.get("DATABASE_HOST") ?? "localhost",
      port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
      username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
      password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
      database: Environment.get("DATABASE_NAME") ?? "vapor_database"
    ), as: .psql)
  }
    // migrations
  app.migrations.add(CreateTodo())
  try app.autoMigrate().wait()
    // webSocket
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
    // web view
  app.views.use(.leaf)
    // register routes
  try routes(app)
}
