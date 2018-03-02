//
// Created by Александр Славщик on 25.02.2018.
// Copyright (c) 2018 Александр Славщик. All rights reserved.
//

import Foundation
import Dispatch

struct Message {
    var message: String
    var wait_ms: Int?
    var terminator: String?
}

class MessagesQueue {

    var messages: [Message] = []
    var queue: DispatchQueue = DispatchQueue(label: "messages", qos: DispatchQoS.userInitiated)

    private func showNextMessage() {
        guard self.messages.count > 0 else { return }

        let rm = self.messages.popLast()!

        guard let t = rm.wait_ms else {
            self.queue.sync(execute: {
                self.printMessage(rm)
                self.showNextMessage()
            })
            return
        }

        self.queue.sync(execute: {
            usleep(useconds_t(t * 1000))
            self.printMessage(rm)
            self.showNextMessage()
        });
    }

    func printMessage(_ m: Message) {
        guard let term = m.terminator else {
            print(m.message)
            return
        }
        print(m.message, terminator: term)
    }

    func push(_ message: String? = nil, _ timeout: Int? = nil, _ terminator: String? = nil) -> Void {
        let msg = message != nil ? message! : ""
        
        self.messages.append(Message(message: msg, wait_ms: timeout, terminator: terminator))
        self.showNextMessage()

    }
}
