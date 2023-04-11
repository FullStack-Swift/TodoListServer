import Fluent

/// Migration Todo
struct CreateTodo: AsyncMigration {
  func prepare(on database: Database) async throws {
    try await database.schema("todos")
      .id()
      .field("title", .string, .required)
      .field("isCompleted", .bool, .required)
      .create()
  }
  
  func revert(on database: Database) async throws {
    try await database.schema("todos").delete()
  }
}
