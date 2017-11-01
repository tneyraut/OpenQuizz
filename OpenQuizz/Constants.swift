//
//  Constants.swift
//  OpenQuizz
//
//  Created by Thomas Mac on 30/10/2017.
//  Copyright © 2017 ThomasNeyraut. All rights reserved.
//

import UIKit

class Constants
{
    static let questionType = "boolean"
    static let baseUrl = "https://opentdb.com/api.php"
    
    static let survivalModInit = false
    static let lifeRecupModInit = false
    static let timeLimitModInit = false
    
    static let nbQuestionsInit = 10
    static let nbQuestionsMin: Float = 10
    static let nbQuestionsMax: Float = 100
    
    static let nbLifeInit = 3
    static let nbLifeMin: Float = 1
    static let nbLifeMax: Float = 15
    
    static let nbGoodAnswerInit = 10
    static let nbGoodAnswerMin: Float = 1
    static let nbGoodAnswerMax: Float = 50
    
    static let nbTimeLimitInit = 10
    static let nbTimeLimitMin: Float = 3
    static let nbTimeLimitMax: Float = 60
    
    static let questionsLoadedNotification = "questionsLoadedNotification"
    static let settingsSavedNotification = "settingsSavedNotification"
    
    // Storyboard and ViewController Id
    static let mainStoryboardId = "Main"
    static let gameViewControllerId = "GameViewController"
    static let settingsViewControllerId = "SettingsViewController"
    
    // Cache Key
    static let hasBeenAlreadyLaunchedCacheKey = "hasBeenAlreadyLaunchedCacheKey"
    static let survivalModCacheKey = "survivalModCacheKey"
    static let nbQuestionsCacheKey = "nbQuestionsCacheKey"
    static let nbLifeCacheKey = "nbLifeCacheKey"
    static let lifeRecupModCacheKey = "lifeRecupModCacheKey"
    static let nbLifeRecupCacheKey = "nbLifeRecupCacheKey"
    static let timeLimitModCacheKey = "timeLimitModCacheKey"
    static let timeLimitCacheKey = "timeLimitCacheKey"
}
