//
//  File 3.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/14/19.
//

import Foundation


class Server {

	static var shared = Server(private: ())

	private init(private: ()) {
		// Only one initialiser is available
	}

	@available(*, unavailable, renamed: "Server.shared", message: "Please use shared instance")
	init() {
		
	}
	
	func configure<E: HTTPEnviroment>(enviroment: E.Type,/* @EnviromentBuilder<E> */ points: () -> ()) {
		points()
	}
	
//	var endPoints: [String: AnyPoint<E>] = [:]
}

class EnviromentRouter<E: HTTPEnviroment> {

//	static var shared: EnviromentRouter = .init()

	var routes: [String: AnyPoint<E>] = [:]

	init() {

	}
}
