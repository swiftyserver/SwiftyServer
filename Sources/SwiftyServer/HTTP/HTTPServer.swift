//
//  File 3.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/14/19.
//

import Foundation
import NIO
import NIOHTTP1


public class Server<E: HTTPEnviroment> {

	let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
	let threadPool = NIOThreadPool(numberOfThreads: 6)


	static func childChannelInitializer(channel: Channel) -> EventLoopFuture<Void> {
		return channel.pipeline.configureHTTPServerPipeline(withErrorHandling: true).flatMap {
			channel.pipeline.addHandler(ServerHandler<E>())
		}
	}


	public init(host: String = "127.0.0.1", port: Int = 9876) {
		threadPool.start()

		let socketBootstrap = ServerBootstrap(group: group)
			// Specify backlog and enable SO_REUSEADDR for the server itself
			.serverChannelOption(ChannelOptions.backlog, value: 256)
			.serverChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)

			// Set the handlers that are applied to the accepted Channels
			.childChannelInitializer(Self.childChannelInitializer(channel:))

			// Enable SO_REUSEADDR for the accepted Channels
			.childChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
			.childChannelOption(ChannelOptions.maxMessagesPerRead, value: 1)
			.childChannelOption(ChannelOptions.allowRemoteHalfClosure, value: false)



		self.channel = try! socketBootstrap.bind(host: host, port: port).wait()
	}

	var channel: Channel

	deinit {
		try! group.syncShutdownGracefully()
		try! threadPool.syncShutdownGracefully()
	}

	public func serve() {
		print(endPoints.routes)
		
		try! channel.closeFuture.wait()
		print("Stop!")
	}


	public func configure(_ points: () -> ()) -> Self {
		print("Start Endpoint Config")
		points()
		print("End Config!")
		return self
	}

	var endPoints: EnviromentRouter<E> = .init()
}


class EnviromentRouter<E: HTTPEnviroment> {

	//	static var shared: EnviromentRouter = .init()

	var curRoute: String? = nil

	func add(path: String, method: String) {
		print("Registered path: \(path), \(method)")
		curRoute = "\(method)|\(path)"
	}

	func add(type: String) {
		print("Registered In Type: \(type)")
	}

	func add(middle name: String) {
		print("Middle Operation registered: \(name)")
	}


	func add(returns type: String, point: AnyPoint<E>) {
		print("Return Type: \(type)")

		if let route = curRoute {
			routes[route] = point
			curRoute = nil
		} else {
			fatalError()
		}
	}

	var routes: [String: AnyPoint<E>] = [:]

	init() {

	}
}
