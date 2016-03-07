//
//  ViewController.swift
//  Quiz
//
//  Created by ian kunneke on 1/18/16.
//  Copyright © 2016 zivit. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        questionLabel.text = questions[currentQuestionIndex]
    }
    
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answerLabel: UILabel!
    
    let questions: [String] = ["From what is cognac made?", "What is 7+7?", "What is the capital of Vermont?"]
    let answers: [String] = ["Grapes","14","Montpelier"]
    
    var currentQuestionIndex: Int = 0
    
    @IBAction func showNextQuestion(sender: AnyObject)
    {
        ++currentQuestionIndex
        if currentQuestionIndex == questions.count
        {
            currentQuestionIndex = 0
        }
        
        let question: String = questions[currentQuestionIndex]
        questionLabel.text = question
        answerLabel.text = "???"
    }
    
    @IBAction func showAnswer(sender:AnyObject)
    {
        let answer: String = answers[currentQuestionIndex]
        answerLabel.text = answer
    }
}

