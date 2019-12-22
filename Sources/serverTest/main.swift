//
//  main.swift
//
//
//  Created by Muhammet Mehmet Emin Kartal.
//

import Foundation

struct User: Identifiable {
	var id: Int
}

struct MyEnviroment: AuthEnviroment, DatabaseEnviroment, HTTPEnviroment {
	init(request: HTTPRequest) { self.httpParameters = request }
	
	var httpParameters: HTTPRequest
	var connection = MySQLDatabase(hostname: "127.0.0.1", database: "testDatabase")
	var currentUser: User?
	
	func auth(with: String) -> User { return User(id: 0) }
}


Server.shared.configure(enviroment: MyEnviroment.self) {
	
	MyEnviroment.get("/hello")
		.map { up, req in "Hello" }
		.map { up, req in "\(up) World"}
		.response()
	
	MyEnviroment.get("/get/\(\.id)", type: GetPostByID.self)
		.getQuery()
		.response()
	
	MyEnviroment.post("/update/", type: GetPostByID.self)
		.auth(from: \.httpParameters.cookies["auth"])
		.check(message: "You need to be authanticated to perform this action")  { up , req  in req.currentUser != nil }
		.getQuery()
		.check(message: "This is not your post") { up, req in up.writer == req.currentUser!.id }
		.repost(type: UpdatePostName.self)
		.query()
		.constant("Your post has been updated!")
		.response()
	
	MyEnviroment.post("/save", type: SavePostRequest.self)
		.auth(from: \.httpParameters.cookies["auth"])
		.check(message: "You need to be authanticated to perform this action") { up , req  in req.currentUser != nil }
		.check(message: "Please enter at least 3 characters for name") { up, req in up.name.count < 3 }
		.map { up, req in SavePost(name: up.name, views: 0, writer: req.currentUser!.id ) }
		.query()
		.map { up, req in "Your post has been created!" }
		.response()
	
}
