//
//  QuizViewController.swift
//  Delta
//
//  Created by Nathan FALLET on 18/03/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController, UITextFieldDelegate {

    let quiz: Quiz
    let completionHandler: (Quiz) -> ()
    let scrollView = UIScrollView()
    let contentView = UIView()
    let header = UILabel()
    let stack = UIStackView()
    let button = UIButton()
    var bottomConstraint: NSLayoutConstraint!
    
    init(_ quiz: Quiz, completionHandler: @escaping (Quiz) -> ()) {
        self.quiz = quiz
        self.completionHandler = completionHandler
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomConstraint = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomConstraint.isActive = true
        
        scrollView.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        contentView.addSubview(header)
        contentView.addSubview(stack)
        contentView.addSubview(button)
        
        header.translatesAutoresizingMaskIntoConstraints = false
        header.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 15).isActive = true
        header.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 15).isActive = true
        header.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -15).isActive = true
        header.font = .boldSystemFont(ofSize: 17)
        header.textAlignment = .center
        header.text = quiz.text
        header.numberOfLines = 0
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 16).isActive = true
        stack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        stack.widthAnchor.constraint(equalToConstant: 300).isActive = true
        stack.axis = .horizontal
        
        for i in 0 ..< quiz.questions.count {
            let question = quiz.questions[i]
            let questionStack = UIStackView()
            let questionLabel = UILabel()
            let questionField = UITextField()
            
            questionStack.axis = .horizontal
            questionStack.spacing = 6

            questionLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
            questionLabel.setContentHuggingPriority(.required, for: .horizontal)
            questionLabel.adjustsFontSizeToFitWidth = true
            questionLabel.text = question.0
            
            questionField.setContentCompressionResistancePriority(.required, for: .horizontal)
            questionField.autocapitalizationType = .none
            questionField.returnKeyType = .done
            questionField.delegate = self
            questionField.tag = i
            questionField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
            
            questionStack.addArrangedSubview(questionLabel)
            questionStack.addArrangedSubview(questionField)
            
            stack.addArrangedSubview(questionStack)
        }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 16).isActive = true
        button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 300).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.bottomAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        button.setTitle("check".localized(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChanged(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChanged(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func buttonClicked(_ sender: UIButton) {
        // Dismiss view
        dismiss(animated: true) {
            // Call completion handler
            self.completionHandler(self.quiz)
        }
    }
    
    @objc func editingChanged(_ sender: UITextField) {
        // Update input
        quiz.questions[sender.tag].2 = sender.text ?? ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    @objc func keyboardChanged(_ sender: NSNotification) {
        if let userInfo = sender.userInfo {
            // Adjust frame to keyboard
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            let isKeyboardShowing = sender.name == UIResponder.keyboardWillShowNotification
            bottomConstraint.constant = isKeyboardShowing ? -((keyboardFrame?.height ?? 0)) : 0
            
            // And animate the transition
            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }

}
