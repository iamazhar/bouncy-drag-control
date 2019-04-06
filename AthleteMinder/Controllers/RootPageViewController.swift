//
//  RootPageViewController.swift
//  AthleteMinder
//
//  Created by Azhar Anwar on 4/7/19.
//  Copyright © 2019 Azhar Anwar. All rights reserved.
//

import UIKit
import AthleteMinderUI

class RootPageViewController: UIPageViewController, UIPageViewControllerDelegate {
    
    lazy var viewControllerList: [UIViewController] = {
        let vc1 = ViewController()
        let vc2 = ViewController()
        let vc3 = ViewController()
        let vc4 = ViewController()
        let vc5 = ViewController()
        
        return [vc1, vc2, vc3, vc4, vc5]
    }()
    
    lazy var navBarView: UIView = {
        let v = UIView()
        v.backgroundColor = AMColor.navigationBarBackground.color
        return v
    }()
    
    let trainingTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "PLAN OF ACTION"
        label.textColor = AMColor.primaryText.color
        label.font = AMFont.mediumCondensed.of(size: AMFontSize.larger)
        return label
    }()
    
    let previousQuestionButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ICON-Back-Training-Tap"), for: .normal)
        return button
    }()
    
    let nextQuestionButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ICON-Next-Training-Tap"), for: .normal)
        return button
    }()
    
    lazy var dotView: UIView = {
        let v = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 24, height: 24)))
        v.layer.cornerRadius = 24
        
        let gradientLayer = CAGradientLayer()
        let topColor = #colorLiteral(red: 0.2431372549, green: 0.8156862745, blue: 0.3921568627, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.3607843137, green: 0.7921568627, blue: 0.5647058824, alpha: 1)
        
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        v.layer.addSublayer(gradientLayer)
        gradientLayer.frame = v.bounds
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        self.dataSource = self
        self.delegate = self
        
        if let firstViewController = viewControllerList.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    fileprivate func setupLayout() {
        
        view.addSubview(navBarView)
        navBarView.addSubview(trainingTitleLabel)
        navBarView.addSubview(previousQuestionButton)
        navBarView.addSubview(nextQuestionButton)
        navBarView.addSubview(dotView)
        
        navBarView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .zero, size: .init(width: 0, height: 100))
        
        trainingTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        trainingTitleLabel.centerXAnchor.constraint(equalTo: navBarView.centerXAnchor).isActive = true
        trainingTitleLabel.centerYAnchor.constraint(equalTo: navBarView.centerYAnchor).isActive = true
        
        previousQuestionButton.anchor(top: nil, leading: navBarView.leadingAnchor, bottom: nil, trailing: nil, padding: .zero, size: .init(width: 64, height: 64))
        previousQuestionButton.centerYAnchor.constraint(equalTo: navBarView.centerYAnchor).isActive = true
        
        nextQuestionButton.anchor(top: nil, leading: nil, bottom: nil, trailing: navBarView.trailingAnchor, padding: .zero, size: .init(width: 64, height: 64))
        nextQuestionButton.centerYAnchor.constraint(equalTo: navBarView.centerYAnchor).isActive = true
        
        dotView.anchor(top: trainingTitleLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil)
        dotView.centerXAnchor.constraint(equalTo: navBarView.centerXAnchor).isActive = true
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension RootPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = viewControllerList.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else { return nil }
        
        guard viewControllerList.count > previousIndex else { return nil }
        
        return viewControllerList[previousIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllerList.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex != viewControllerList.count else { return nil }
        
        guard viewControllerList.count > nextIndex else { return nil }
        
        return viewControllerList[nextIndex]
    }
}