//
//  IntentHandler.swift
//  Person
//
//  Copyright © 2019 Blackbaud. All rights reserved.
//

import Intents

class IntentHandler: INExtension {

    override func handler(for intent: INIntent) -> Any {
        if intent is PersonInfoIntent {
            return PersonInfoIntentHandler()
        }
        if intent is FileContactReportIntent {
            return FileContactReportIntentHandler()
        }
//        if intent is INGetVisualCodeIntent {
//            return GetVisualCodeIntentHandler()
//        }
//        if intent is INAddTasksIntent {
//            return AddTasksIntentHandler()
//        }
//        if intent is INCreateNoteIntent {
//            return CreateNoteIntentHandler()
//        }

        fatalError("Unhandled Intent error : \(intent)")

    }

}

