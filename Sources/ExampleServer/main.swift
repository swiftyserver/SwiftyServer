//
//  main.swift
//
//
//  Created by Muhammet Mehmet Emin Kartal.
//

import Foundation
import SwiftyServer

import CryptoSwift

//let password: Array<UInt8> = Array("s33krit".utf8)
//let salt: Array<UInt8> = Array("nacllcan".utf8)
//
//let key = try! PKCS5.PBKDF2(password: password, salt: salt, iterations: 512, keyLength: 32, variant: .sha256).calculate()


struct MyUser: Identifiable {
	var id: Int
}


struct MyEnviroment: AutoAuthEnviroment, DatabaseEnviroment, HTTPEnviroment {
	static var Server: Server<MyEnviroment> = .init()

	init(httpParameters request: HTTPRequest) { self.httpParameters = request }

	static var AuthPath: KeyPath<MyEnviroment, String?> = \.httpParameters.cookies["auth"]
	static var connection = MySQLDatabase(hostname: "127.0.0.1", database: "testDatabase")

	var httpParameters: HTTPRequest

	var currentUser: MyUser?
	
	func auth(with: String) -> MyUser { return User(id: 0) }
}

extension MyEnviroment: ErrorHandlingEnviroment {
	enum ErrorType: Error {
		case unauthorized
		case invalidPostName
		case postNotFound
	}
}

MyEnviroment.Server.configure {
	MyEnviroment.get("/hello")
		.map { up, req in "Hello" }
		.map { up, req in "\(up) World"}
		.response()

	MyEnviroment.post("/hello", type: String.self)
		.map { up, req in "Hello \(up)" }
		.response()

	//	MyEnviroment.get("/get/\(\.id)", type: GetPostByID.self)
	//		.getQuery()
	//		.response()

	MyEnviroment.simpleActionPost(path: "/newUser", action: NewUser.self)
		.constant("Success")
		.response()

	MyEnviroment.post("/update", type: GetPostByID.self)
		.auth()
		.assert(.unauthorized)  { _, req  in req.currentUser != nil }
		.getQuery()
		.check(message: "This is not your post") { post, req in post.writer == req.currentUser!.id }
		.repost(type: UpdatePostName.self)
		.query()
		.constant("Your post has been updated!")
		.response()
	
	MyEnviroment.post("/save", type: SavePostRequest.self)
		.auth()
		.assert(.unauthorized)  { _, req  in req.currentUser != nil }
		.check(message: "Please enter at least 3 characters for name") { post, req in post.name.count < 3 }
		.map { up, req in SavePostQuery(name: up.name, views: 0, writer: req.currentUser!.id ) }
		.query()
		.map { up, req in "Your post has been created!" }
		.response()
}.serve()
