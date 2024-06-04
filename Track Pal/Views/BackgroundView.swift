//
//  BackgroundView.swift
//  Track Pal
//
//  Created by Abdulla Rayes on 12/08/2023.
//

import SwiftUI

struct BackgroundView: View {
    @Environment (\.colorScheme) var colorScheme

    var body: some View {
        
            if colorScheme == .light {
                lightAppBackground.ignoresSafeArea()
            } else {
                darkAppBackground.ignoresSafeArea()
            }
        
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
