//
//  ImageZoomInView+SwiftUI.swift
//  NotificationFeature
//
//  Created by 이나연 on 11/19/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import SwiftUI

import MDS

struct ImageZoomInView: View {
    let imageUrl: String
    let onClose: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color(uiColor: SemanticColor.Bg.Dim.default)
                .ignoresSafeArea()
            
            imageSection
                .padding(.horizontal, 20)
                .frame(maxHeight: .infinity)
            
            closeButton
                .padding(.top, 21)
                .padding(.trailing, 20)
        }
        
    }
}

extension ImageZoomInView {
    private var imageSection: some View {
        Rectangle()
            .fill(Color(uiColor: SemanticColor.Bg.Neutral.subtle))
            .aspectRatio(contentMode: .fit)
    }
    
    private var closeButton: some View {
        Button(action: onClose) {
            Image(uiImage: MDSIcon.xCloseOutlined.image)
                .renderingMode(.template)
                .resizable()
                .foregroundColor(Color(uiColor: SemanticColor.Fg.Neutral.bold))
                .frame(width: 24, height: 24)
                .frame(width: 44, height: 44)
        }
    }
}
