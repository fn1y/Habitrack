//
//  OpenAIInterface.swift
//  Habit Tracker
//
//  Created by Study Mode on 28/12/2023.
//
//  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

import Foundation
import OpenAIKit

let openAIKey = "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"
let openAIOrg = "org-tKrL4lcr3inmn1agp5Z98II4"

let urlSession = URLSession(configuration: .default)
let configuration = Configuration(apiKey: openAIKey, organization: openAIOrg)
let openAIClient = OpenAIKit.Client(session: urlSession, configuration: configuration)

func AiTest() async{
    
    let completion = try? await openAIClient.completions.create(
        model: Model.GPT3.davinci,
        prompts: ["Write a haiku"]
    )
    
    let returnString = "\(String(describing: completion))"
    
    print(returnString)
    
}

func AiTestTask(){
    Task{
        await AiTest()
    }
}
