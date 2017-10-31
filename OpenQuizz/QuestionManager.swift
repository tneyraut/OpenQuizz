//
//  QuestionManager.swift
//  OpenQuizz
//
//  Created by Thomas Mac on 30/10/2017.
//  Copyright © 2017 ThomasNeyraut. All rights reserved.
//

import UIKit

class QuestionManager
{
    static let singleton = QuestionManager()
    
    func getQuestions(nbQuestions: Int, questionType: String, completionHandler: @escaping ([Question]) -> ())
    {
        let url = URL(string: "\(Constants.baseUrl)?amount=\(nbQuestions)&type=\(questionType)")
        
        let task = URLSession.shared.dataTask(with: url!)
        { (data, response, error) in
            guard error == nil
            else
            {
                completionHandler([Question]())
                return
            }
            DispatchQueue.main.async
            {
                completionHandler(self.parse(data: data))
            }
        }
        task.resume()
    }
    
    private func parse(data: Data?) -> [Question]
    {
        guard let data = data,
        let serializedJson = try? JSONSerialization.jsonObject(with: data, options: []),
        let parsedJson = serializedJson as? [String: Any],
        let results = parsedJson["results"] as? [[String: Any]]
        else
        {
            return [Question]()
        }
        return getQuestionsFrom(parsedDatas: results)
    }
    
    private func getQuestionsFrom(parsedDatas: [[String: Any]]) -> [Question]
    {
        var retrievedQuestions = [Question]()
        
        for parsedData in parsedDatas
        {
            retrievedQuestions.append(getQuestionFrom(parsedData: parsedData))
        }
        
        return retrievedQuestions
    }
    
    private func getQuestionFrom(parsedData: [String: Any]) -> Question
    {
        if let title = parsedData["question"] as? String,
            let answer = parsedData["correct_answer"] as? String
        {
            return Question(title: String(htmlEncodedString: title)!, isCorrect: (answer == "True"))
        }
        return Question()
    }
}
