//
//  ViewController.swift
//  OpenQuizz
//
//  Created by Thomas Mac on 30/10/2017.
//  Copyright © 2017 ThomasNeyraut. All rights reserved.
//

import UIKit
import AudioToolbox

class GameViewController: UIViewController
{
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var newGameButton: RoundedButton!
    @IBOutlet weak var questionView: QuestionView!
    @IBOutlet weak var wrongButton: RoundedButton!
    @IBOutlet weak var correctButton: RoundedButton!
    
    private var timer = Timer()
    
    private let userDefaults = UserDefaults()
    
    private let game = GameModel()
    
    private var nbAnswerCorrect = 0
    
    private var nbLife = 0
    {
        didSet
        {
            if userDefaults.bool(forKey: Constants.survivalModCacheKey)
            {
                navigationItem.leftBarButtonItem = UIBarButtonItem(
                    title: "\(NSLocalizedString("GAME_VIEW_LIFE", comment: "")) \(nbLife)",
                    style: .done,
                    target: nil,
                    action: nil)
            }
            else
            {
                navigationItem.leftBarButtonItem = nil
            }
        }
    }
    
    // check timer il y a un petit problème dans le endless mode...
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = NSLocalizedString("GAME_VIEW_TITLE", comment: "")
        
        newGameButton.setTitle(NSLocalizedString("GAME_VIEW_NEW_GAME", comment: ""), for: .normal)
        wrongButton.setTitle(NSLocalizedString("GAME_VIEW_WRONG", comment: ""), for: .normal)
        correctButton.setTitle(NSLocalizedString("GAME_VIEW_CORRECT", comment: ""), for: .normal)
        
        newGameButton.layer.borderColor = AppColors.lightBlue.cgColor
        wrongButton.layer.borderColor = AppColors.red.cgColor
        correctButton.layer.borderColor = AppColors.green.cgColor
        
        let settingsButton = UIButton(type: .custom)
        settingsButton.setImage(#imageLiteral(resourceName: "settings"), for: .normal)
        settingsButton.tintColor = AppColors.gray
        settingsButton.addTarget(self, action: #selector(goToSettingsCommand), for: .touchUpInside)
        settingsButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingsButton)
        
        activityIndicator.startAnimating()
        
        NotificationCenter.default.addObserver(self, selector: #selector(questionsLoaded), name: NSNotification.Name(rawValue: Constants.questionsLoadedNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(settingsSaved), name: NSNotification.Name(rawValue: Constants.settingsSavedNotification), object: nil)
        
        startNewGame()
        
        let panGestureRecognize = UIPanGestureRecognizer(target: self, action: #selector(dragQuestionView(_:)))
        
        questionView.addGestureRecognizer(panGestureRecognize)
    }
    
    @objc private func settingsSaved()
    {
        startNewGame()
    }
    
    @objc private func goToSettingsCommand()
    {
        timer.invalidate()
        
        let storyboard = UIStoryboard(name: Constants.mainStoryboardId, bundle: nil)
        
        let settingsViewController = storyboard.instantiateViewController(withIdentifier: Constants.settingsViewControllerId)
        
        showModal(viewController: settingsViewController)
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
        timer.invalidate()
        
        let answerIsCorrect = game.answer(answer: answer)
        
        updateScore()
        
        if answerIsCorrect
        {
            animateScoreLabel(color: AppColors.green)
        }
        else
        {
            animateScoreLabel(color: AppColors.red)
        }
        
        let canContinu = checkLifeCanContinu(answerIsCorrect: answerIsCorrect)
        
        if !canContinu
        {
            game.finishGame()
        }
        
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
        
        let gameState = game.getState()
        
        if gameState == .ongoing
        {
            questionView.question = game.getCurrentQuestionTitle()
        }
        else if gameState == .needMoreQuestions
        {
            questionView.question = NSLocalizedString("GAME_VIEW_LOADING", comment: "")
        }
        else
        {
            questionView.question = NSLocalizedString("GAME_VIEW_GAME_OVER", comment: "")
            
            UIView.animate(withDuration: 0.5, animations: { self.questionView.transform = CGAffineTransform(rotationAngle: CGFloat.pi) })
            
            UIView.animate(withDuration: 0.5, delay: 0.25, options: .curveEaseIn, animations: { self.questionView.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0) }, completion: nil)
        }
        
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5,
            options: [],
            animations: { self.questionView.transform = .identity },
            completion: { (success) in
                if gameState == .ongoing
                {
                    self.launchTimer()
                }
            })
    }
    
    @objc private func questionsLoaded()
    {
        activityIndicator.setHiddenAnimated(hidden: true)
        newGameButton.setHiddenAnimated(hidden: false)
        
        questionView.question = game.getCurrentQuestionTitle()
        
        launchTimer()
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
        timer.invalidate()
        
        nbAnswerCorrect = 0
        nbLife = userDefaults.integer(forKey: Constants.nbLifeCacheKey)
        
        newGameButton.setHiddenAnimated(hidden: true)
        activityIndicator.setHiddenAnimated(hidden: false)
        
        questionView.question = NSLocalizedString("GAME_VIEW_LOADING", comment: "")
        questionView.style = .standard
        
        game.newGame()
        
        updateScore()
    }
    
    private func updateScore()
    {
        scoreLabel.text = userDefaults.bool(forKey: Constants.survivalModCacheKey) ? "\(game.getScore()) \(NSLocalizedString("GAME_VIEW_CORRECT_ANSWERS", comment: ""))" : "\(game.getScore()) / \(userDefaults.integer(forKey: Constants.nbQuestionsCacheKey))"
    }
    
    private func launchTimer()
    {
        if !userDefaults.bool(forKey: Constants.timeLimitModCacheKey)
        {
            return
        }
        
        timer = Timer.scheduledTimer(
            timeInterval: TimeInterval(userDefaults.integer(forKey: Constants.timeLimitCacheKey)),
            target: self,
            selector: #selector(timerCommand),
            userInfo: nil,
            repeats: true)
    }
    
    @objc private func timerCommand()
    {
        timer.invalidate()
        
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        let canContinu = checkLifeCanContinu(answerIsCorrect: false)
        
        if !canContinu
        {
            game.finishGame()
        }
        
        game.timeElapsed()
        
        showQuestionView()
    }
    
    private func checkLifeCanContinu(answerIsCorrect: Bool) -> Bool
    {
        if !userDefaults.bool(forKey: Constants.survivalModCacheKey)
        {
            return true
        }
        
        nbAnswerCorrect = answerIsCorrect ? nbAnswerCorrect + 1 : 0
        
        if !answerIsCorrect
        {
            nbLife -= 1
            
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        
        if userDefaults.bool(forKey: Constants.lifeRecupModCacheKey) && nbAnswerCorrect == userDefaults.integer(forKey: Constants.nbLifeRecupCacheKey)
        {
            nbAnswerCorrect = 0
            
            nbLife += 1
        }
        
        return nbLife > 0
    }
    
    private func animateScoreLabel(color: UIColor)
    {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5,
            options: [],
            animations:
            {
                self.scoreLabel.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                
                self.scoreLabel.textColor = color
            },
            completion: { (success) in
                self.scoreLabel.transform = .identity
                
                self.scoreLabel.textColor = AppColors.gray
            })
    }
}

