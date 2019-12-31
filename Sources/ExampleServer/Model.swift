//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/21/19.
//

import Foundation
import SwiftyServer



struct SavePostQuery: SQLAction, Codable {
	static var SQLString: SQLString<SavePostQuery> = "INSERT INTO posts(name, views) VALUES (\(\SavePostQuery.name), \(\SavePostQuery.views))"
	
	var name: String
	var views: Int
	var writer: Int
}
struct UpdatePostName: SQLAction, Codable {
	static var SQLString: SQLString<UpdatePostName> = "UPDATE posts SET name = \(\UpdatePostName.name) WHERE id = \(\UpdatePostName.id)"
	
	var id: Int
	var name: String
}

struct SavePostRequest: Codable {
	var name: String
}

struct UpdatePostRequest: Codable {
	var id: Int
	var name: String
}


struct GetPostByID: SQLView, Codable {
	static var SQLString: SQLString<GetPostByID> = "SELECT * FROM posts WHERE id = \(\GetPostByID.id)"
	
	var id: Int
	
	struct Result: Codable {
		var name: String
		var views: Int
		var writer: Int
	}
}
