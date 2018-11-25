//
//  ShareView.swift
//  PlacticeNet
//
//  Created by 城島一輝 on 2018/11/22.
//  Copyright © 2018 城島一輝. All rights reserved.
//

import UIKit

class ShareView: NSObject {
    
    var activityItems: [Any] = []
    
    func showActivityViewController(willShareText: String, willShareImage: UIImage) -> UIViewController {
        
        activityItems = [willShareText, willShareImage]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        // 使わない機能を決める事も出来る
        let excludedActivityTypes = [
            UIActivity.ActivityType.message,
            UIActivity.ActivityType.print
        ]
        
        activityVC.excludedActivityTypes = excludedActivityTypes
        
        return activityVC
    }
}
