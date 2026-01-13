//
//  CustomPopupView.swift
//  HelloAlfred
//
//  Created by MAC on 1/30/25.
//


import UIKit

class CustomPopupView: UIView {
    
    // MARK: - Closure
    var onRestart: (() -> Void)?
    var onOkay: (() -> Void)?
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Are you sure, Do you want to reset?"
        label.font = UIFont(name: "Poppins-Regular", size: 14.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Are you sure, Do you want to reset?"
        label.font = UIFont(name: "Poppins-Regular", size: 14.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let restartButton: UIButton = {
        let button = UIButton()
        button.setTitle("Yes", for: .normal)
        button.backgroundColor = UIColor(red: 4/255, green: 193/255, blue: 214/255, alpha: 1.0)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 14.0)
        return button
    }()
    
    private let okButton: UIButton = {
        let button = UIButton()
        button.setTitle("No", for: .normal)
        button.backgroundColor = UIColor(red: 245/255, green: 74/255, blue: 104/255, alpha: 1.0)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 14.0)
        return button
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        addSubview(containerView)
        containerView.addSubview(titleLabel)
//        containerView.addSubview(messageLabel)
        containerView.addSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(restartButton)
        buttonStackView.addArrangedSubview(okButton)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            containerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),

            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
//            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
//            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
//            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            buttonStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            buttonStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            buttonStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            buttonStackView.heightAnchor.constraint(equalToConstant: 41)
        ])
    }
    
    private func setupActions() {
        okButton.addTarget(self, action: #selector(dismissPopup), for: .touchUpInside)
        restartButton.addTarget(self, action: #selector(restartAction), for: .touchUpInside)
    }
    
    // MARK: - Presentation
    func show(in view: UIView) {
        self.frame = view.bounds
        view.addSubview(self)
        
        // Animation
        containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.3) {
            self.containerView.transform = .identity
        }
    }
    
    // MARK: - Actions
    @objc private func dismissPopup() {
        onOkay?()
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    @objc private func restartAction() {
        // Handle restart logic
        onRestart?()
        dismissPopup()
    }
}

