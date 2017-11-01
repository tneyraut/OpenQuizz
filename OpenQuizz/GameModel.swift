//
//  Game.swift
//  OpenQuizz
//
//  Created by Thomas Mac on 30/10/2017.
//  Copyright © 2017 ThomasNeyraut. All rights reserved.
//

import UIKit

class GameModel
{
    private let userDefaults = UserDefaults()
    
    private var score = 0
    
    private var questions = [Question]()
    private var currentIndex = 0
    
    private var state: State = .ongoing
    
    private var currentQuestion: Question
    {
        return questions[currentIndex]
    }
    
    func getCurrentQuestionTitle() -> String
    {
        return currentQuestion.getTitle()
    }
    
    func getScore() -> Int
    {
        return score
    }
    
    func getState() -> State
    {
        return state
    }
    
    func newGame()
    {
        score = 0
        
        loadQuestions()
    }
    
    private func loadQuestions()
    {
        state = .needMoreQuestions
        
        currentIndex = 0
        
        let nbQuestions = userDefaults.bool(forKey: Constants.survivalModCacheKey) ? 50 : userDefaults.integer(forKey: Constants.nbQuestionsCacheKey)
        
        QuestionManager.singleton.getQuestions(
            nbQuestions: nbQuestions,
            questionType: Constants.questionType,
            completionHandler:
            { (questions) in
                self.questions = questions
                self.state = .ongoing
                
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: Constants.questionsLoadedNotification)))
        })
    }
    
    func answer(answer: Bool) -> Bool
    {
        let answerIsCorrect = currentQuestion.answerIsCorrect(answer: answer)
        
        if answerIsCorrect
        {
            score += 1
        }
        goToNextQuestion()
        
        return answerIsCorrect
    }
    
    func timeElapsed()
    {
        goToNextQuestion()
    }
    
    private func goToNextQuestion()
    {
        if currentIndex < questions.count - 1
        {
            currentIndex += 1
        }
        else if userDefaults.bool(forKey: Constants.survivalModCacheKey)
        {
            loadQuestions()
        }
        else
        {
            finishGame()
        }
    }
    
    func finishGame()
    {
        state = .over
    }
}
