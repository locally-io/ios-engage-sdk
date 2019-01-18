//
//  Scheduler.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 19/11/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation
import PromiseKit
import UserNotifications

typealias Callback = ((Scheduler) -> Void)

class Scheduler {

	private enum State {
		case running
		case stopped
	}

	enum Mode {
		case infinite
		case once
	}

	private var mode: Mode

	private var state = State.stopped

	private var callback: Callback?

	private var interval: TimeInterval

	private var delay: TimeInterval?

	private var deadline: DispatchTime {
		guard let delay = delay else {
			return DispatchTime.now() + interval
		}
		return DispatchTime.now() + delay
	}

	var isRunning: Bool { return state == .running }

	private lazy var timer: DispatchSourceTimer = {
		let queue = DispatchQueue(label: "com.aus.scheduler.\(NSUUID().uuidString)")
		let flags = DispatchSource.TimerFlags(rawValue: 0)
		let timer = DispatchSource.makeTimerSource(flags: flags, queue: queue)
		timer.schedule(deadline: deadline, repeating: interval)
		timer.setEventHandler { [weak self] in
			self?.timerEventHandler()
		}
		return timer
	}()

	init(interval: TimeInterval, delay: TimeInterval? = nil, mode: Mode = .infinite, callback: @escaping Callback) {
		self.interval = interval
		self.delay = delay
		self.mode = mode
		self.callback = callback
	}

	@discardableResult
	static func runOnce(interval: TimeInterval = 1, delay: TimeInterval? = nil, callback: @escaping Callback) -> Scheduler {
		let scheduler = Scheduler(interval: interval, delay: delay, mode: .once, callback: callback)
		scheduler.start()
		return scheduler
	}

	@discardableResult
	static func runEvery(interval: TimeInterval = 1, delay: TimeInterval? = nil, callback: @escaping Callback) -> Scheduler {
		let scheduler = Scheduler(interval: interval, delay: delay, mode: .infinite, callback: callback)
		scheduler.start()
		return scheduler
	}

	func start() {

		guard state != .running else { return }

		timer.resume()

		state = .running
	}

	func stop() {

		guard state != .stopped else { return }

		timer.suspend()

		state = .stopped
	}

	private func timerEventHandler() {

		callback?(self)

		switch mode {
			case .infinite: break
			case .once: stop()
		}
	}

	deinit {
		timer.setEventHandler(handler: nil)
		timer.cancel()

		callback = nil
		timer.resume()
	}
}
