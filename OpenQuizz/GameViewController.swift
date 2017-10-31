//
//  ViewController.swift
//  OpenQuizz
//
//  Created by Thomas Mac on 30/10/2017.
//  Copyright © 2017 ThomasNeyraut. All rights reserved.
//

import UIKit

class GameViewController: UIViewController
{
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var questionView: QuestionView!
    
    private let game = GameModel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        
        NotificationCenter.default.addObserver(self, selector: #selector(questionsLoaded), name: NSNotification.Name(rawValue: Constants.questionsLoadedNotification), object: nil)
        
        startNewGame()
        
        let panGestureRecognize = UIPanGestureRecognizer(target: self, action: #selector(dragQuestionView(_:)))
        
        questionView.addGestureRecognizer(panGestureRecognize)
    }
    
    @objc private func dragQuestionView(_ sender: UIPanGestureRecognizer)
    {
        if game.getState() == .over
        {
            return
        }
        
        switch sender.state
        {
        case .began, .changed:
            transformQuestionViewWith(gesture: sender)
            break
        case .ended, .cancelled:
            answerQuestion()
            break
        default:
            break
        }
    }
    
    private func transformQuestionViewWith(gesture: UIPanGestureRecognizer)
    {
        let translation = gesture.translation(in: questionView)
        let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
        
        let translationPercent = translation.x / (UIScreen.main.bounds.width / 2)
        let rotationAngle = (CGFloat.pi / 6) * translationPercent
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
        
        let transform = translationTransform.concatenating(rotationTransform)
        
        questionView.transform = transform
        
        if translation.x > 0 {
            questionView.style = .correct
        } else {
            questionView.style = .incorrect
        }
    }
    
    private func answerQuestion()
    {
        switch questionView.style
        {
            case .correct:
                game.answer(answer: true)
            case .incorrect:
                game.answer(answer: false)
            case .standard:
                break
        }
        
        updateScore()
        
        let screenWidth = UIScreen.main.bounds.width
        
        var translationTransform: CGAffineTransform
        if questionView.style == .correct
        {
            translationTransform = CGAffineTransform(translationX: screenWidth, y: 0)
        }
        else
        {
            translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
        }
        
        UIView.animate(withDuration: 0.3, animations:
        {
            self.questionView.transform = translationTransform
        }, completion: { (success) in
            if success
            {
                self.showQuestionView()
            }
        })
    }
    
    private func showQuestionView()
    {
        questionView.transform = .identity
        questionView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        questionView.style = .standard
        
        if game.getState() == .ongoing
        {
            questionView.question = game.getCurrentQuestionTitle()
        }
        else
        {
            questionView.question = "Game Over"
        }
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: { self.questionView.transform = .identity }, completion: nil)
    }
    
    @objc private func questionsLoaded()
    {
        activityIndicator.isHidden = true
        newGameButton.isHidden = false
        
        questionView.question = game.getCurrentQuestionTitle()
    }
    
    @IBAction func newGameCommand()
    {
        startNewGame()
    }
    
    private func startNewGame()
    {
        newGameButton.isHidden = true
        activityIndicator.isHidden = false
        
        questionView.question = "Loading..."
        questionView.style = .standard
        
        game.newGame()
        
        updateScore()
    }
    
    private func updateScore()
    {
        scoreLabel.text = "\(game.getScore()) / \(Constants.nbQuestions)"
    }
}

