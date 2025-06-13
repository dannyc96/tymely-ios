//
//  TymelyWidgetBundle.swift
//  TymelyWidget
//
//  Created by Danny Chambers on 6/12/25.
//

import WidgetKit
import SwiftUI

@main
struct TymelyWidgetBundle: WidgetBundle {
    var body: some Widget {
        TymelyWidget()
        if #available(iOS 18.0, *) {
            TymelyWidgetControl()
        }
        TymelyWidgetLiveActivity()
    }
}
