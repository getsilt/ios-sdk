//
//  SiltTrademark.swift
//  SiltSDK
//
//  Created by Marc on 22/04/2020.
//  Copyright © 2020 Silt. All rights reserved.
//

import UIKit

public class SiltTrademark: UILabel {
    
    public override init (frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        let SiltSDKBundle = Bundle(for: SiltTrademark.self as AnyClass)
        let siltLogo = UIImage(named: "silt_blue.png", in: SiltSDKBundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
        
        
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = siltLogo
        let image1String = NSAttributedString(attachment: image1Attachment)
        
        image1Attachment.bounds = CGRect(x: CGFloat(0), y: (font.capHeight - (siltLogo?.size.height)!) / 2, width: (siltLogo?.size.width)!, height: (siltLogo?.size.height)!)

        let fullString = NSMutableAttributedString(string: "Powered by ")
        fullString.append(image1String)
        self.attributedText = fullString
    }
    
}
