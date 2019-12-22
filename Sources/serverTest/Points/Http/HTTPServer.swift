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
	
	func configure<E: RequestEnviroment>(enviroment: E.Type,/* @EnviromentBuilder<E> */ points: () -> ()) {

	}

}
