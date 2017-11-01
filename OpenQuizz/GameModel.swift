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
        currentIndex = 0
        state = .over
        
        let userDefaults = UserDefaults()
        
        QuestionManager.singleton.getQuestions(
            nbQuestions: userDefaults.integer(forKey: Constants.nbQuestionsCacheKey),
            questionType: Constants.questionType,
            completionHandler:
            { (questions) in
                self.questions = questions
                self.state = .ongoing
                
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: Constants.questionsLoadedNotification)))
            })
    }
    
    func answer(answer: Bool)
    {
        if currentQuestion.answerIsCorrect(answer: answer)
        {
            score += 1
        }
        goToNextQuestion()
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
        else
        {
            finishGame()
        }
    }
    
    private func finishGame()
    {
        state = .over
    }
}
