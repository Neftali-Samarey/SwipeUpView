//
//  ViewController.swift
//  DraggablePopover
//
//  Created by Neftali Samarey on 1/11/20.
//  Copyright © 2020 Neftali Samarey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum CardState {
        case collapsed
        case expanded
    }
    
    var cardVisible = false
    
    var nextState:CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    // Slider property
    var slider : SliderViewController!
    
    // Visual effects
    var visualEffectsView : UIVisualEffectView!
    
    // Starting and end slider heights
    var endCardHeight:CGFloat = 0
    var startCardHeight:CGFloat = 0
    
    // Empty property animator
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupSlider()
    }
    
    
    func setupSlider() {
        // Starting and ending of slider card height
        endCardHeight = self.view.frame.height * 0.8
        startCardHeight = self.view.frame.height * 0.3
        
        // Adding visual effects
        visualEffectsView = UIVisualEffectView()
        visualEffectsView.frame = self.view.frame
        self.view.addSubview(visualEffectsView)
        
        // Add slider card to the bottom of the screen and by clipping bounds for rounded corners
        slider = SliderViewController(nibName: "SliderViewController", bundle: nil)
        self.view.addSubview(slider.view)
        slider.view.frame = CGRect(x: 0, y: self.view.frame.height - startCardHeight, width: self.view.bounds.width, height: endCardHeight)
        slider.view.clipsToBounds = true
        
    
        // Add Gesture recornizers
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleCardTap(recognzier:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ViewController.handleCardPan(recognizer:)))

        slider.handleArea.addGestureRecognizer(tapGestureRecognizer)
        slider.handleArea.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    // Handle tap gesture recognizer
    @objc func handleCardTap(recognzier:UITapGestureRecognizer) {
        switch recognzier.state {
            // Animate card when tap finishes
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.9)
        default:
            break
        }
    }
    
    
    // Handle pan gesture recognizer
    @objc func handleCardPan (recognizer:UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            // Start animation if pan begins
            startInteractiveTransition(state: nextState, duration: 0.9)
            
        case .changed:
            // Update the translation according to the percentage completed
            let translation = recognizer.translation(in: self.slider.handleArea)
            var fractionComplete = translation.y / endCardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            // End animation when pan ends
            continueInteractiveTransition()
        default:
            break
        }
    }
    
    
    
    // Animate transistion function
       func animateTransitionIfNeeded (state:CardState, duration:TimeInterval) {
           // Check if frame animator is empty
           if runningAnimations.isEmpty {
               // Create a UIViewPropertyAnimator depending on the state of the popover view
               let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                   switch state {
                   case .expanded:
                       // If expanding set popover y to the ending height and blur background
                       self.slider.view.frame.origin.y = self.view.frame.height - self.endCardHeight
                       self.visualEffectsView.effect = UIBlurEffect(style: .dark)
      
                   case .collapsed:
                       // If collapsed set popover y to the starting height and remove background blur
                       self.slider.view.frame.origin.y = self.view.frame.height - self.startCardHeight
                       
                       self.visualEffectsView.effect = nil
                   }
               }
               
               // Complete animation frame
               frameAnimator.addCompletion { _ in
                   self.cardVisible = !self.cardVisible
                   self.runningAnimations.removeAll()
               }
               
               // Start animation
               frameAnimator.startAnimation()
               
               // Append animation to running animations
               runningAnimations.append(frameAnimator)
               
               // Create UIViewPropertyAnimator to round the popover view corners depending on the state of the popover
               let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                   switch state {
                   case .expanded:
                       // If the view is expanded set the corner radius to 30
                       self.slider.view.layer.cornerRadius = 30
                       
                   case .collapsed:
                       // If the view is collapsed set the corner radius to 0
                       self.slider.view.layer.cornerRadius = 0
                   }
               }
               
               // Start the corner radius animation
               cornerRadiusAnimator.startAnimation()
               
               // Append animation to running animations
               runningAnimations.append(cornerRadiusAnimator)
               
           }
       }
       
       // Function to start interactive animations when view is dragged
       func startInteractiveTransition(state:CardState, duration:TimeInterval) {
           
           // If animation is empty start new animation
           if runningAnimations.isEmpty {
               animateTransitionIfNeeded(state: state, duration: duration)
           }
           
           // For each animation in runningAnimations
           for animator in runningAnimations {
               // Pause animation and update the progress to the fraction complete percentage
               animator.pauseAnimation()
               animationProgressWhenInterrupted = animator.fractionComplete
           }
       }
       
       // Funtion to update transition when view is dragged
       func updateInteractiveTransition(fractionCompleted:CGFloat) {
           // For each animation in runningAnimations
           for animator in runningAnimations {
               // Update the fraction complete value to the current progress
               animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
           }
       }
       
       // Function to continue an interactive transisiton
       func continueInteractiveTransition (){
           // For each animation in runningAnimations
           for animator in runningAnimations {
               // Continue the animation forwards or backwards
               animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
           }
       }


}

