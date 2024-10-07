//
//  Font+Extension.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 04/10/24.
//

//import SwiftUI
//
//extension Font {
//    static func appSystem(style: SFProTextStyle) -> Font {
//        let font = sys
//
//    }
//}
//
//enum SFProTextStyle: String {
//    case title
//
//}

import Foundation
import SwiftUI

extension Font {
    ///
    /// Use the closest weight if your typeface does not support a particular weight
    ///
    static private var fontFamily: String = "SFProText"
    
    static private var regularFontName: String {
        "\(fontFamily)-Regular"
    }
    
    static private var boldFontName: String {
        "\(fontFamily)-Bold"
    }
    
    static private var semiBoldFontName: String {
        "\(fontFamily)-Semibold"
    }
    
    /// Sizes
    private static var preferredSizeTitle: CGFloat {
        UIFont.preferredFont(forTextStyle: .title1).pointSize
    }
    
    private static var preferredLargeTitle: CGFloat {
        UIFont.preferredFont(forTextStyle: .largeTitle).pointSize
    }
    
    private static var preferredExtraLargeTitle: CGFloat {
        if #available(iOS 17.0, *) {
            UIFont.preferredFont(forTextStyle: .extraLargeTitle).pointSize
        } else {
            UIFont.preferredFont(forTextStyle: .largeTitle).pointSize
        }
    }
    
    private static var preferredExtraLargeTitle2: CGFloat {
        if #available(iOS 17.0, *) {
            UIFont.preferredFont(forTextStyle: .extraLargeTitle2).pointSize
        } else {
            UIFont.preferredFont(forTextStyle: .largeTitle).pointSize
        }
    }
    
    private static var preferredTitle1: CGFloat {
        UIFont.preferredFont(forTextStyle: .title1).pointSize
    }
    
    private static var preferredTitle2: CGFloat {
        UIFont.preferredFont(forTextStyle: .title2).pointSize
    }
    
    private static var preferredTitle3: CGFloat {
        UIFont.preferredFont(forTextStyle: .title3).pointSize
    }
    
    private static var preferredHeadline: CGFloat {
        UIFont.preferredFont(forTextStyle: .headline).pointSize
    }
    
    private static var preferredSubheadline: CGFloat {
        UIFont.preferredFont(forTextStyle: .subheadline).pointSize
    }
    
    private static var preferredBody: CGFloat {
        UIFont.preferredFont(forTextStyle: .body).pointSize
    }
    
    private static var preferredCallout: CGFloat {
        UIFont.preferredFont(forTextStyle: .callout).pointSize
    }
    
    private static var preferredFootnote: CGFloat {
        UIFont.preferredFont(forTextStyle: .footnote).pointSize
    }
    
    private static var preferredCaption: CGFloat {
        UIFont.preferredFont(forTextStyle: .caption1).pointSize
    }
    
    private static var preferredCaption2: CGFloat {
        UIFont.preferredFont(forTextStyle: .caption2).pointSize
    }
    
    /// Styles
    public static var title: Font {
        return Font.custom(regularFontName, size: preferredTitle1)
    }
    
    public static var title2: Font {
        return Font.custom(regularFontName, size: preferredTitle2)
    }
    
    public static var title3: Font {
        return Font.custom(regularFontName, size: preferredTitle3)
    }
    
    public static var largeTitle: Font {
        return Font.custom(regularFontName, size: preferredLargeTitle)
    }
    
    public static var body: Font {
        return Font.custom(regularFontName, size: preferredBody)
    }
    
    public static var headline: Font {
        return Font.custom(regularFontName, size: preferredHeadline)
    }
    
    public static var subheadline: Font {
        return Font.custom(regularFontName, size: preferredSubheadline)
    }
    
    public static var callout: Font {
        return Font.custom(regularFontName, size: preferredCallout)
    }
    
    public static var footnote: Font {
        return Font.custom(regularFontName, size: preferredFootnote)
    }
    
    public static var caption: Font {
        return Font.custom(regularFontName, size: preferredCaption)
    }
    
    public static var caption2: Font {
        return Font.custom(regularFontName, size: preferredCaption2)
    }
    
    public static func system(_ style: Font.TextStyle, design: Font.Design? = nil, weight: Font.Weight? = nil) -> Font {
        var size: CGFloat
        var font: String
        
        switch style {
        case .largeTitle:
            size = preferredLargeTitle
        case .title:
            size = preferredTitle1
        case .title2:
            size = preferredTitle2
        case .title3:
            size = preferredTitle3
        case .headline:
            size = preferredHeadline
        case .subheadline:
            size = preferredSubheadline
        case .body:
            size = preferredBody
        case .callout:
            size = preferredCallout
        case .footnote:
            size = preferredFootnote
        case .caption:
            size = preferredCaption
        case .caption2:
            size = preferredCaption2
        case .extraLargeTitle:
            size = preferredExtraLargeTitle
        case .extraLargeTitle2:
            size = preferredExtraLargeTitle2
        default:
            size = preferredBody
        }
        
        switch weight {
        case .bold:
            font = boldFontName
        case .regular:
            font = regularFontName
        case .semibold:
            font = semiBoldFontName
        default:
            font = regularFontName
        }
        
        return Font.custom(font, size: size)
    }
    
    public static func system(_ style: Font.TextStyle, design: Font.Design? = nil) -> Font {
        var size: CGFloat
        var font: String = regularFontName
        
        switch style {
        case .largeTitle:
            size = preferredLargeTitle
            font = boldFontName
        case .title:
            size = preferredTitle1
            font = boldFontName
        case .title2:
            size = preferredTitle2
            font = boldFontName
        case .title3:
            size = preferredTitle3
            font = semiBoldFontName
        case .headline:
            size = preferredHeadline
            font = semiBoldFontName
        case .subheadline:
            size = preferredSubheadline
            font = regularFontName
        case .body:
            size = preferredBody
            font = regularFontName
        case .callout:
            size = preferredCallout
            font = boldFontName
        case .footnote:
            size = preferredFootnote
            font = regularFontName
        case .caption:
            size = preferredCaption
            font = regularFontName
        case .caption2:
            size = preferredCaption2
            font = boldFontName
        case .extraLargeTitle:
            size = preferredExtraLargeTitle
        case .extraLargeTitle2:
            size = preferredExtraLargeTitle2
        default:
            size = preferredBody
            font = regularFontName
        }
        
        return Font.custom(font, size: size)
    }
    
    public static func system(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> Font {
        var font: String
        
        switch weight {
        case .bold:
            font = boldFontName
        case .regular:
            font = regularFontName
        case .semibold:
            font = semiBoldFontName
        default:
            font = regularFontName
        }
        
        return Font.custom(font, size: size)
    }
}
