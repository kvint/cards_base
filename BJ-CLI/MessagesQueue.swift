//
// Created by Александр Славщик on 25.02.2018.
// Copyright (c) 2018 Александр Славщик. All rights reserved.
//

import Foundation
import Dispatch

struct Message {
    var message: String
    var wait_ms: Int?
}

class MessagesQueue {

    var messages: [Message] = []
    var queue: DispatchQueue = DispatchQueue(label: "messages")

    private func showNextMessage() {
        guard self.messages.count > 0 else { return }

        let rm = self.messages.popLast()

        guard let t = rm!.wait_ms else {
            self.queue.sync(execute: {
                print(rm!.message)
                self.showNextMessage()
            })
            return
        }

        self.queue.sync(execute: {
            print(rm!.message)
            usleep(useconds_t(t * 1000))
            self.showNextMessage()
        });
    }

    func push(_ message: String? = nil, _ timeout: Int? = nil) -> Void {
        let msg = message != nil ? message! : ""
        
        self.messages.append(Message(message: msg, wait_ms: timeout))
        self.showNextMessage()

    }
}
