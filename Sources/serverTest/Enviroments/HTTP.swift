//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/21/19.
//

import Foundation


protocol HTTPEnviroment: RequestEnviroment {
	var httpParameters: HTTPRequest { get }

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
	
	var path: String
	var type: String
	var body: Data?
	var cookies: [String: String]
	var headers: [String: String]
}
