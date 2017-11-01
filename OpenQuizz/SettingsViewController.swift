//
//  SettingsViewController.swift
//  OpenQuizz
//
//  Created by Thomas Mac on 31/10/2017.
//  Copyright © 2017 ThomasNeyraut. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController
{
    @IBOutlet weak var survivalModSwitch: UISwitch!
    @IBOutlet weak var survivalModLabel: UILabel!
    
    @IBOutlet weak var nbQuestionsLabel: UILabel!
    @IBOutlet weak var nbQuestionsSlider: UISlider!
    
    @IBOutlet weak var nbLifesLabel: UILabel!
    @IBOutlet weak var nbLifesSlider: UISlider!
    
    @IBOutlet weak var lifeRecupModSwitch: UISwitch!
    @IBOutlet weak var lifeRecupModLabel: UILabel!
    
    @IBOutlet weak var nbLifeRecupLabel: UILabel!
    @IBOutlet weak var nbLifeRecupSlider: UISlider!
    
    @IBOutlet weak var timeLimitModSwitch: UISwitch!
    @IBOutlet weak var timeLimitModLabel: UILabel!
    
    @IBOutlet weak var timeLimitLabel: UILabel!
    @IBOutlet weak var timeLimitSlider: UISlider!
    
    private let userDefaults = UserDefaults()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        initSwitchsAndSliders()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: NSLocalizedString("SHARE_SAVE", comment: ""),
            style: .done,
            target: self,
            action: #selector(saveCommand))
    }
    
    @objc private func saveCommand()
    {
        userDefaults.set(survivalModSwitch.isOn, forKey: Constants.survivalModCacheKey)
        userDefaults.set(lifeRecupModSwitch.isOn, forKey: Constants.lifeRecupModCacheKey)
        userDefaults.set(timeLimitModSwitch.isOn, forKey: Constants.timeLimitModCacheKey)
        
        userDefaults.set(nbQuestionsSlider.value, forKey: Constants.nbQuestionsCacheKey)
        userDefaults.set(nbLifesSlider.value, forKey: Constants.nbLifeCacheKey)
        userDefaults.set(nbLifeRecupSlider.value, forKey: Constants.nbLifeRecupCacheKey)
        userDefaults.set(timeLimitSlider.value, forKey: Constants.timeLimitCacheKey)
        
        userDefaults.synchronize()
        
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: Constants.settingsSavedNotification)))
        
        closeModal()
    }
    
    private func initSwitchsAndSliders()
    {
        survivalModSwitch.setOn(userDefaults.bool(forKey: Constants.survivalModCacheKey), animated: true)
        survivalModSwitch.addTarget(self, action: #selector(survivalModValueChange), for: .touchUpInside)
        
        lifeRecupModSwitch.setOn(userDefaults.bool(forKey: Constants.lifeRecupModCacheKey), animated: true)
        lifeRecupModSwitch.addTarget(self, action: #selector(lifeRecupModValueChange), for: .touchUpInside)
        
        timeLimitModSwitch.setOn(userDefaults.bool(forKey: Constants.timeLimitModCacheKey), animated: true)
        timeLimitModSwitch.addTarget(self, action: #selector(timeLimitModValueChange), for: .touchUpInside)
        
        nbQuestionsSlider.maximumValue = Constants.nbQuestionsMax
        nbQuestionsSlider.minimumValue = Constants.nbQuestionsMin
        nbQuestionsSlider.value = userDefaults.float(forKey: Constants.nbQuestionsCacheKey)
        nbQuestionsSlider.addTarget(self, action: #selector(sliderValueChange), for: .valueChanged)
        
        nbLifesSlider.maximumValue = Constants.nbLifeMax
        nbLifesSlider.minimumValue = Constants.nbLifeMin
        nbLifesSlider.value = userDefaults.float(forKey: Constants.nbLifeCacheKey)
        nbLifesSlider.addTarget(self, action: #selector(sliderValueChange), for: .valueChanged)
        
        nbLifeRecupSlider.maximumValue = Constants.nbGoodAnswerMax
        nbLifeRecupSlider.minimumValue = Constants.nbGoodAnswerMin
        nbLifeRecupSlider.value = userDefaults.float(forKey: Constants.nbLifeRecupCacheKey)
        nbLifeRecupSlider.addTarget(self, action: #selector(sliderValueChange), for: .valueChanged)
        
        timeLimitSlider.maximumValue = Constants.nbTimeLimitMax
        timeLimitSlider.minimumValue = Constants.nbTimeLimitMin
        timeLimitSlider.value = userDefaults.float(forKey: Constants.timeLimitCacheKey)
        timeLimitSlider.addTarget(self, action: #selector(sliderValueChange), for: .valueChanged)
        
        survivalModValueChange()
        lifeRecupModValueChange()
        timeLimitModValueChange()
    }
    
    @objc private func survivalModValueChange()
    {
        setLabelText()
        
        nbQuestionsSlider.setHiddenAnimated(hidden: survivalModSwitch.isOn)
        nbQuestionsLabel.setHiddenAnimated(hidden: survivalModSwitch.isOn)
        
        nbLifesLabel.setHiddenAnimated(hidden: !survivalModSwitch.isOn)
        nbLifesSlider.setHiddenAnimated(hidden: !survivalModSwitch.isOn)
        
        lifeRecupModSwitch.setHiddenAnimated(hidden: !survivalModSwitch.isOn)
        lifeRecupModLabel.setHiddenAnimated(hidden: !survivalModSwitch.isOn)
        
        if !survivalModSwitch.isOn
        {
            nbLifeRecupLabel.setHiddenAnimated(hidden: !survivalModSwitch.isOn)
            nbLifeRecupSlider.setHiddenAnimated(hidden: !survivalModSwitch.isOn)
        }
        else
        {
            lifeRecupModValueChange()
        }
    }
    
    @objc private func lifeRecupModValueChange()
    {
        setLabelText()
        
        nbLifeRecupLabel.setHiddenAnimated(hidden: !lifeRecupModSwitch.isOn)
        nbLifeRecupSlider.setHiddenAnimated(hidden: !lifeRecupModSwitch.isOn)
    }
    
    @objc private func timeLimitModValueChange()
    {
        setLabelText()
        
        timeLimitLabel.setHiddenAnimated(hidden: !timeLimitModSwitch.isOn)
        timeLimitSlider.setHiddenAnimated(hidden: !timeLimitModSwitch.isOn)
    }
    
    @objc private func sliderValueChange()
    {
        setLabelText()
    }
    
    private func setLabelText()
    {
        title = NSLocalizedString("SETTINGS_VIEW_TITLE", comment: "")
        
        survivalModLabel.text = "\(NSLocalizedString("SETTINGS_VIEW_SURVIVAL_MOD", comment: "")) \(survivalModSwitch.getStringValue())"
        
        nbQuestionsLabel.text = "\(NSLocalizedString("SETTINGS_VIEW_NB_QUESTIONS", comment: "")) \(Int(nbQuestionsSlider.value))"
        
        nbLifesLabel.text = "\(NSLocalizedString("SETTINGS_VIEW_NB_LIFE", comment: "")) \(Int(nbLifesSlider.value))"
        
        lifeRecupModLabel.text = "\(NSLocalizedString("SETTINGS_VIEW_LIFE_RECUP_MOD", comment: "")) \(lifeRecupModSwitch.getStringValue())"
        
        nbLifeRecupLabel.text = "\(NSLocalizedString("SETTINGS_VIEW_GET_LIFE", comment: "")) \(Int(nbLifeRecupSlider.value)) \(NSLocalizedString("SETTINGS_VIEW_GOOD_ANSWERS", comment: ""))"
        
        timeLimitModLabel.text = "\(NSLocalizedString("SETTINGS_VIEW_TIME_LIMIT_MOD", comment: "")) \(timeLimitModSwitch.getStringValue())"
        
        timeLimitLabel.text = "\(NSLocalizedString("SETTINGS_VIEW_TIME_LIMIT", comment: "")) \(Int(timeLimitSlider.value)) \(NSLocalizedString("SHARE_SECONDE", comment: ""))"
    }
}
