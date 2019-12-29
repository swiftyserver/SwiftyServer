//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/21/19.
//

import Foundation


protocol HTTPEnviroment: RequestEnviroment {
	var httpParameters: HTTPRequest { get }
	static var Server: Server<Self> { get }
	init(request: HTTPRequest)
}

class HTTPRequest {
	internal init(path: String, type: String, body: Data?, cookies: [String : String], headers: [String : String]) {
		self.path = path
		self.type = type
		self.body = body
		self.cookies = cookies
		self.headers = headers
	}
	
	public private(set) var path: String
	public private(set) var type: String
	public private(set) var body: Data?
	public private(set) var cookies: [String: String]
	public private(set) var headers: [String: String]
}

extension HTTPEnviroment {
	static func serve() {
		Self.Server.serve()
	}
}
