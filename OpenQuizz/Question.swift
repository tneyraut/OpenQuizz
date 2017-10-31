//
//  Question.swift
//  OpenQuizz
//
//  Created by Thomas Mac on 30/10/2017.
//  Copyright © 2017 ThomasNeyraut. All rights reserved.
//

class Question
{
    private let title: String!
    private let isCorrect: Bool!
    
    init()
    {
        self.title = ""
        self.isCorrect = false
    }
    
    init(title: String, isCorrect: Bool)
    {
        self.title = title
        self.isCorrect = isCorrect
    }
    
    func answerIsCorrect(answer: Bool) -> Bool
    {
        return (isCorrect && answer) || (!isCorrect && !answer)
    }
    
    func getTitle() -> String
    {
        return title
    }
}
