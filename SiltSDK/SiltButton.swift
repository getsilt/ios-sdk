//
//  CustomButton.swift
//  silt-sdk-storyboard
//
//  Created by Marc on 21/04/2020.
//  Copyright © 2020 Silt. All rights reserved.
//

import UIKit

public class SiltButton: UIButton {
    
    var buttonStyle: String = "silver";
    public final var siltColorBlue = UIColor(red:41/255, green:99/255, blue:255/255, alpha: 1)
    public final var siltColorSilver = UIColor(red:240/255, green:240/255, blue:240/255, alpha: 1)
    
    public init (frame: CGRect, bStyle: String ) {
        super.init(frame: frame)
        buttonStyle = bStyle
        setupButton()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

//    public override func viewDidLoad() {
//        super.viewDidLoad()
//        setupButton()
//    }
    
    public func setStyle(bStyle: String) {
        buttonStyle = bStyle
    }
    
    private func setupButton() {
        styleButton()
        setRightImage()
        sizeToFit()
        setInsets(forContentPadding: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20), imageTitlePadding: 10)
        
    }
    
    private func styleButton() {
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        translatesAutoresizingMaskIntoConstraints = false
        
        if (buttonStyle == "blue") {
            setTitleColor(.white, for: .normal)
            backgroundColor = siltColorBlue
        } else {
            setTitleColor(.darkGray, for: .normal)
            backgroundColor = siltColorSilver
        }
        
    }
    
    public override func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        super.setTitleColor(color, for: state)
    }
    
    private func setRightImage() {
        let SiltSDKBundle = Bundle(for: SiltButton.self)
        semanticContentAttribute = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        
        if (buttonStyle == "blue") {
            setImage(
            UIImage(named: "silt_white.png", in: SiltSDKBundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
            , for: .normal)
        } else {
            setImage(
            UIImage(named: "silt_blue.png", in: SiltSDKBundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
            , for: .normal)
        }
//
        
        imageView?.contentMode = .scaleToFill
    }
    
    public func setInsets(
        forContentPadding contentPadding: UIEdgeInsets,
        imageTitlePadding: CGFloat
    ) {
        self.contentEdgeInsets = UIEdgeInsets(
            top: contentPadding.top,
            left: contentPadding.left + imageTitlePadding,
            bottom: contentPadding.bottom,
            right: contentPadding.right
        )
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: -imageTitlePadding,
            bottom: 0,
            right: imageTitlePadding
        )
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupButton()
        layer.cornerRadius = (frame.height)/2
        
    }
}
