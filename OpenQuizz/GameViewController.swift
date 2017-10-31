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
    @IBOutlet weak var wrongButton: UIButton!
    @IBOutlet weak var correctButton: UIButton!
    
    private let game = GameModel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        newGameButton.setTitle(NSLocalizedString("GAME_VIEW_NEW_GAME", comment: ""), for: .normal)
        wrongButton.setTitle(NSLocalizedString("GAME_VIEW_WRONG", comment: ""), for: .normal)
        correctButton.setTitle(NSLocalizedString("GAME_VIEW_CORRECT", comment: ""), for: .normal)
        
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
            switch questionView.style
            {
                case .correct:
                    answerQuestion(answer: true)
                    break
                case .incorrect:
                    answerQuestion(answer: false)
                    break
                default:
                    break
            }
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
    
    private func answerQuestion(answer: Bool)
    {
        game.answer(answer: answer)
        
        updateScore()
        
        let screenWidth = UIScreen.main.bounds.width
        
        var translationTransform: CGAffineTransform
        if answer
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
            questionView.question = NSLocalizedString("GAME_VIEW_GAME_OVER", comment: "")
        }
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: { self.questionView.transform = .identity }, completion: nil)
    }
    
    @objc private func questionsLoaded()
    {
        activityIndicator.setHiddenAnimated(hidden: true)
        newGameButton.setHiddenAnimated(hidden: false)
        
        questionView.question = game.getCurrentQuestionTitle()
    }
    
    @IBAction func wrongCommand()
    {
        if game.getState() == .over
        {
            return
        }
        questionView.style = .incorrect
        
        answerQuestion(answer: false)
    }
    
    @IBAction func correctCommand()
    {
        if game.getState() == .over
        {
            return
        }
        questionView.style = .correct
        
        answerQuestion(answer: true)
    }
    
    @IBAction func newGameCommand()
    {
        startNewGame()
    }
    
    private func startNewGame()
    {
        newGameButton.setHiddenAnimated(hidden: true)
        activityIndicator.setHiddenAnimated(hidden: false)
        
        questionView.question = NSLocalizedString("GAME_VIEW_LOADING", comment: "")
        questionView.style = .standard
        
        game.newGame()
        
        updateScore()
    }
    
    private func updateScore()
    {
        scoreLabel.text = "\(game.getScore()) / \(Constants.nbQuestions)"
    }
}

