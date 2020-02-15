//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/28/19.
//

import Foundation

import NIO
import NIOHTTP1


private func httpResponseHead(request: HTTPRequestHead, status: HTTPResponseStatus, headers: HTTPHeaders = HTTPHeaders()) -> HTTPResponseHead {
    var head = HTTPResponseHead(version: request.version, status: status, headers: headers)
    let connectionHeaders: [String] = head.headers[canonicalForm: "connection"].map { $0.lowercased() }


//	print(#function + " returning headers for \(request) with status: \(status)")

    if !connectionHeaders.contains("keep-alive") && !connectionHeaders.contains("close") {
        // the user hasn't pre-set either 'keep-alive' or 'close', so we might need to add headers
        switch (request.isKeepAlive, request.version.major, request.version.minor) {
        case (true, 1, 0):
            // HTTP/1.0 and the request has 'Connection: keep-alive', we should mirror that
            head.headers.add(name: "Connection", value: "keep-alive")
        case (false, 1, let n) where n >= 1:
            // HTTP/1.1 (or treated as such) and the request has 'Connection: close', we should mirror that
            head.headers.add(name: "Connection", value: "close")
        default:
            // we should match the default or are dealing with some HTTP that we don't support, let's leave as is
            ()
        }
    }
    return head
}



class ServerHandler<E: HTTPEnviroment>: ChannelInboundHandler {
	public typealias InboundIn = HTTPServerRequestPart
	public typealias OutboundOut = HTTPServerResponsePart



	func getPointFor(path: String, method: String) -> AnyPoint<E>? {
		print("\(method)|\(path)")
		return E.Server.endPoints.routes["\(method)|\(path)"]
	}

	private enum State {
		case idle
		case waitingForRequestBody
		case sendingResponse

		mutating func requestReceived() {

			precondition(self == .idle, "Invalid state for request received: \(self)")
			self = .waitingForRequestBody
		}

		mutating func requestComplete() {

			precondition(self == .waitingForRequestBody, "Invalid state for request complete: \(self)")
			self = .sendingResponse
		}

		mutating func responseComplete() {
			precondition(self == .sendingResponse, "Invalid state for response complete: \(self)")
			self = .idle
		}
	}

	private var buffer: ByteBuffer! = nil
	private var keepAlive = false
	private var state = State.idle {
		didSet {
//			print("Setted state: \(state)")
		}
	}

	private var requestHead: HTTPRequestHead?

	private let defaultResponse = "Hello World\r\n"



    func handlerAdded(context: ChannelHandlerContext) {
        self.buffer = context.channel.allocator.buffer(capacity: 0)
    }

	func userInboundEventTriggered(context: ChannelHandlerContext, event: Any) {

		print(#function + "\(event) ----")

        switch event {
        case let evt as ChannelEvent where evt == ChannelEvent.inputClosed:
            // The remote peer half-closed the channel. At this time, any
            // outstanding response will now get the channel closed, and
            // if we are idle or waiting for a request body to finish we
            // will close the channel immediately.
            switch self.state {
            case .idle, .waitingForRequestBody:
                context.close(promise: nil)
            case .sendingResponse:
                self.keepAlive = false
            }
        default:
            context.fireUserInboundEventTriggered(event)
        }

	}
	func channelRead(context: ChannelHandlerContext, data: NIOAny) {

		let reqPart = self.unwrapInboundIn(data)


		switch reqPart {
		case .head(let request):
//			print("Head of \(request)")
			self.requestHead = request
			self.keepAlive = request.isKeepAlive
			self.state.requestReceived()
		case .body(buffer: var buf):
//			print("Body Data!")

			self.buffer.writeBuffer(&buf)

		case .end(_):

//			print("We the \(requestHead!.method), \(requestHead!.uri)") need to get

			if let point = self.getPointFor(path: requestHead!.uri, method: requestHead!.method.rawValue) {
//				print("Point Found!")

				context.eventLoop.execute {


//					let body = self.buffer.getString(at: <#T##Int#>, length: <#T##Int#>)

					let body = self.buffer.withUnsafeReadableBytes { p in
						Data(bytes: p.baseAddress!, count: self.buffer.readableBytes)
					}



					let request = HTTPRequest(path: self.requestHead!.uri, type: self.requestHead!.method.rawValue, body: body, cookies: [:], headers: [:])
					let enviroment = E.init(httpParameters: request)
					
					do {
						self.state.requestComplete()
						try point.perform(start: enviroment) { finalData, enviroment in

							self.buffer.clear()
							self.buffer.writeBytes(finalData)

							var headers = HTTPHeaders()
							headers.add(name: "Content-Length", value: "\(self.buffer.readableBytes)")
							context.write(self.wrapOutboundOut(.head(httpResponseHead(request: self.requestHead!, status: .ok, headers: headers))), promise: nil)
							context.write(self.wrapOutboundOut(.body(.byteBuffer(self.buffer))), promise: nil)
							self.completeResponse(context, trailers: nil, promise: nil)
						}


					} catch {

						print("Got error!", error)

						let response = "Error \(error.localizedDescription)"
						self.buffer.clear()
						self.buffer.writeString(response)
						var headers = HTTPHeaders()
						headers.add(name: "Content-Length", value: "\(self.buffer.readableBytes)")
						context.write(self.wrapOutboundOut(.head(httpResponseHead(request: self.requestHead!, status: .ok, headers: headers))), promise: nil)
						context.write(self.wrapOutboundOut(.body(.byteBuffer(self.buffer))), promise: nil)
						self.completeResponse(context, trailers: nil, promise: nil)

					}
				}

			} else {
				self.state.requestComplete()
				let response = "Not Found"
				self.buffer.clear()
				self.buffer.writeString(response)
				var headers = HTTPHeaders()
				headers.add(name: "Content-Length", value: "\(buffer.readableBytes)")
				context.write(self.wrapOutboundOut(.head(httpResponseHead(request: self.requestHead!, status: .ok, headers: headers))), promise: nil)
				context.write(self.wrapOutboundOut(.body(.byteBuffer(self.buffer))), promise: nil)
				self.completeResponse(context, trailers: nil, promise: nil)

			}

		}
	}

	private func completeResponse(_ context: ChannelHandlerContext, trailers: HTTPHeaders?, promise: EventLoopPromise<Void>?) {
		self.state.responseComplete()

		let promise = self.keepAlive ? promise : (promise ?? context.eventLoop.makePromise())
		if !self.keepAlive {
			promise!.futureResult.whenComplete { (_: Result<Void, Error>) in context.close(promise: nil) }
		}
//		self.handler = nil

		context.writeAndFlush(self.wrapOutboundOut(.end(trailers)), promise: promise)
	}

	func channelReadComplete(context: ChannelHandlerContext) {
		context.flush()
	}

}
