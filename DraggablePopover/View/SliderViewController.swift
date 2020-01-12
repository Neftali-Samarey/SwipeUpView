//
//  SliderViewController.swift
//  DraggablePopover
//
//  Created by Neftali Samarey on 1/11/20.
//  Copyright © 2020 Neftali Samarey. All rights reserved.
//

import UIKit

class SliderViewController: UIViewController {
    
    @IBOutlet weak var handleArea: UIView!
    
    let animatedGIFImage : UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        
        return imageview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        handleArea.addSubview(animatedGIFImage)
        
        //let gifReference = UIImage.gif(name: "up")
        animatedGIFImage.loadGif(name: "up_black")
        // Add GIF imageview container some constrains
        animatedGIFImage.topAnchor.constraint(equalTo: handleArea.topAnchor, constant: 5).isActive = true
        animatedGIFImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        animatedGIFImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        animatedGIFImage.centerXAnchor.constraint(equalTo: handleArea.centerXAnchor, constant: 0).isActive = true
        
    }
    
    func shadowHandleArea() {
       // handleArea.layer.cornerRadius = 13.0
        handleArea.layer.shadowColor = UIColor.lightGray.cgColor
        handleArea.layer.shadowOpacity = 0.5
        handleArea.layer.shadowRadius = 10.0
        handleArea.layer.shadowOffset = CGSize(width: 0, height: 5)
        //handleArea.layer.shadowPath = UIBezierPath(rect: self.view.bounds).cgPath
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

enum VerticalLocation: String {
    case bottom
    case top
}

extension UIView {
    func addShadow(location: VerticalLocation, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        switch location {
        case .bottom:
             addShadow(offset: CGSize(width: 0, height: 10), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -10), color: color, opacity: opacity, radius: radius)
        }
    }

    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        
    }
}
