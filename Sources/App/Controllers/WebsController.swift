import Vapor

//struct WebController: RouteCollection {
//  func boot(routes: RoutesBuilder) throws {
//    let webs = routes.grouped("webs")
//    webs.get("root", use: getRootView(req:))
//    webs.get("login", use: getLoginView(req:))
//    webs.get("register", use: getRegisterView(req:))
//    webs.get("main", use: getMainView(req:))
//  }
//  // getRootView
//  func getRootView(req: Request) throws -> EventLoopFuture<View> {
//    return RootView().render(with: RootContent(title: "Root View"), for: req)
//  }
//    // getLoginView
//  func getLoginView(req: Request) throws -> EventLoopFuture<View> {
//    return LoginView().render(with: LoginContent(title: "Login View"), for: req)
//  }
//    // getRegisterView
//  func getRegisterView(req: Request) throws -> EventLoopFuture<View> {
//    return RegisterView().render(with: RegisterContent(title: "Register View"), for: req)
//  }
//    // getMainView
//  func getMainView(req: Request) throws -> EventLoopFuture<View> {
//    Todo.query(on: req.db).all().flatMap { todos in
//      return MainView().render(with: MainContent(title: "Main View", todos: todos.asTasks()), for: req)
//    }
//  }
//}
