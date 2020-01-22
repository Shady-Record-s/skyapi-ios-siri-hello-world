// This commented out code is included because it may be useful to someone.
// It is definitely incomplete and should only be used as a starting point or reference.
// T-ODOs have a character added so they don't show up as tasks in various IDEs or when searching.

// The reason I did not use this code in the final demo is because the system
// "Add Tasks" intent does not behave the way I would want to be able to add
// a task to a specific constituent, and it is not much extra effort to just
// write a custom intent that does exactly what I want.

////
////  AddTasksIntentHandler.swift
////  Person
////
////  Created by Christi Schneider on 12/23/19.
////  Copyright © 2019 Blackbaud. All rights reserved.
////
//
//import Foundation
//import Intents
//import os
//import SkyApiCore
//
//class AddTasksIntentHandler : NSObject, INAddTasksIntentHandling {
//
//    func resolveTargetTaskList(for intent: INAddTasksIntent, with completion: (INAddTasksTargetTaskListResolutionResult) -> Void) {
//
//        print("AddTasksIntentHandler.resolveTargetTaskList")
//
//        if let ttl = intent.targetTaskList {
//            print("ttl: \(ttl)")
//
//            // T-ODO check that this is a constituent and save the ID
//            completion(INAddTasksTargetTaskListResolutionResult(taskListResolutionResult: INTaskListResolutionResult.success(with: ttl)))
//
//        } else {
//            print("ttl: nil")
//
//            completion(INAddTasksTargetTaskListResolutionResult(taskListResolutionResult: INTaskListResolutionResult.needsValue()))
//        }
//
//    }
//
//    func resolveTaskTitles(for intent: INAddTasksIntent, with completion: ([INSpeakableStringResolutionResult]) -> Void) {
//
//        print("AddTasksIntentHandler.resolveTaskTitles")
//
//        if let tt = intent.taskTitles {
//            print("tt: \(tt)")
//
//            completion(tt.map { INSpeakableStringResolutionResult.success(with: $0) })
//        } else {
//            print("tt: nil")
//
//            completion([INSpeakableStringResolutionResult.needsValue()])
//        }
//
//    }
//
//    func resolveSpatialEventTrigger(for intent: INAddTasksIntent, with completion: (INSpatialEventTriggerResolutionResult) -> Void) {
//
//        print("AddTasksIntentHandler.resolveSpatialEventTrigger")
//
//        if let set = intent.spatialEventTrigger {
//            print("set: \(set)")
//
//            completion(INSpatialEventTriggerResolutionResult.success(with: set))
//        } else {
//            print("set: nil")
//
//            completion(INSpatialEventTriggerResolutionResult.notRequired())
//        }
//    }
//
//    func resolvePriority(for intent: INAddTasksIntent, with completion: (INTaskPriorityResolutionResult) -> Void) {
//
//        print("AddTasksIntentHandler.resolvePriority")
//
//        print("priority: \(intent.priority)")
//
//        if intent.priority == INTaskPriority.unknown {
//            completion(INTaskPriorityResolutionResult.notRequired())
//        } else {
//            completion(INTaskPriorityResolutionResult.success(with: intent.priority))
//        }
//
//    }
//
//    func confirm(intent: INAddTasksIntent, completion: (INAddTasksIntentResponse) -> Void) {
//
//        print("AddTasksIntentHandler.confirm")
//
//        completion(INAddTasksIntentResponse(code: INAddTasksIntentResponseCode.success, userActivity: nil))
//
//    }
//
//    func handle(intent: INAddTasksIntent, completion: (INAddTasksIntentResponse) -> Void) {
//
//        print("AddTasksIntentHandler.handle")
//
//        completion(INAddTasksIntentResponse(code: INAddTasksIntentResponseCode.success, userActivity: nil))
//
//
//
//        guard let constituentName = intent.targetTaskList?.title.spokenPhrase,
//            let temporalEventTrigger = intent.temporalEventTrigger
//            else {
//
//                // T-ODO
////                completion(INAddTasksIntentResponseCode.)
//                return
//        }
//
//        SkyApiAuthentication.retrieveAccessToken(groupName: "group.com.blackbaud.bbshortcuts1", completionHandler: { (accessToken) in
//            guard let accessToken = accessToken else {
//                // T-ODO
//                //                let activity = NSUserActivity(activityType: "com.blackbaud.Siri-Demo")
//                //                completion(INSpeakableStringResolutionResult(code: .failureRequiringAppLaunch, userActivity: activity))
//                return
//            }
//
//            let api = ConstituentApi()
//
//            api.findConstituent(accessToken: accessToken, searchText: constituentName, completion: { result, error in
//                if let _ = error {
//                    // T-ODO
//                    return
//                }
//
//                guard let result = result else {
//                    // T-ODO
//                    return
//                }
//
//                let constituentId = result.id
//
//                api.createAction(accessToken: accessToken, constituentId: constituentId, category: <#T##String#>, summary: <#T##String#>, date: <#T##Date#>, completion: <#T##(Error?) -> Void#>)
//
//            })
//
//            api.createNote(accessToken: accessToken, constituentId: constituentId, summary: title, text: contentText, type: "Personal", completion: { error in
//                if let _ = error {
//                    // T-ODO
//                    return
//                }
//                completion(INCreateNoteIntentResponse(code: INCreateNoteIntentResponseCode.success, userActivity: nil))
//                return
//            })
//        })
//    }
//
//    func resolveTemporalEventTrigger(for intent: INAddTasksIntent, with completion: (INAddTasksTemporalEventTriggerResolutionResult) -> Void) {
//
//        print("AddTasksIntentHandler.resolveTemporalEventTrigger")
//
//        if let tet = intent.temporalEventTrigger {
//            print("tet: \(tet)")
//
////            if let recurrence = tet.dateComponentsRange.recurrenceRule {
////
////            }
//
//            completion(INAddTasksTemporalEventTriggerResolutionResult.success(with: tet))
//        } else {
//            print("tet: nil")
//
//            completion(INAddTasksTemporalEventTriggerResolutionResult.needsValue())
//        }
//
//    }
//
//}
