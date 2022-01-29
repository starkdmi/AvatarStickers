//
//  PersonShape.swift
//  TGStickersImport
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import SwiftUI

// Shapes code generation - https://github.com/quassum/SVG-to-SwiftUI

struct BodyShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        
        path.move(to: CGPoint(x: 0.10688*width, y: 0.97543*height))
        path.addCurve(to: CGPoint(x: 0.40214*width, y: 0.69274*height), control1: CGPoint(x: 0.11364*width, y: 0.81841*height), control2: CGPoint(x: 0.24347*width, y: 0.69274*height))
        path.addLine(to: CGPoint(x: 0.60773*width, y: 0.69274*height))
        path.addCurve(to: CGPoint(x: 0.90299*width, y: 0.97543*height), control1: CGPoint(x: 0.7664*width, y: 0.69274*height), control2: CGPoint(x: 0.89625*width, y: 0.81841*height))
        path.addLine(to: CGPoint(x: 0.10688*width, y: 0.97543*height))
        path.closeSubpath()
                    
        return path
    }
}

struct NeckShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        
        path.move(to: CGPoint(x: 0.50493*width, y: 0.76984*height))
        path.addCurve(to: CGPoint(x: 0.38929*width, y: 0.70464*height), control1: CGPoint(x: 0.42221*width, y: 0.76984*height), control2: CGPoint(x: 0.3942*width, y: 0.71582*height))
        path.addLine(to: CGPoint(x: 0.38929*width, y: 0.56425*height))
        path.addLine(to: CGPoint(x: 0.62058*width, y: 0.56425*height))
        path.addLine(to: CGPoint(x: 0.62058*width, y: 0.70467*height))
        path.addCurve(to: CGPoint(x: 0.50493*width, y: 0.76984*height), control1: CGPoint(x: 0.61575*width, y: 0.71572*height), control2: CGPoint(x: 0.58776*width, y: 0.76984*height))
        path.closeSubpath()
                    
        return path
    }
}

struct FaceShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height

        path.move(to: CGPoint(x: 0.50493*width, y: 0.66704*height))
        path.addCurve(to: CGPoint(x: 0.46274*width, y: 0.65083*height), control1: CGPoint(x: 0.48941*width, y: 0.66704*height), control2: CGPoint(x: 0.47482*width, y: 0.66144*height))
        path.addLine(to: CGPoint(x: 0.4604*width, y: 0.6488*height))
        path.addLine(to: CGPoint(x: 0.45742*width, y: 0.64805*height))
        path.addCurve(to: CGPoint(x: 0.31219*width, y: 0.46145*height), control1: CGPoint(x: 0.37192*width, y: 0.62634*height), control2: CGPoint(x: 0.31219*width, y: 0.54963*height))
        path.addLine(to: CGPoint(x: 0.31219*width, y: 0.22248*height))
        path.addCurve(to: CGPoint(x: 0.39731*width, y: 0.1543880142*height), control1: CGPoint(x: 0.31219*width, y: 0.18794383*height), control2: CGPoint(x: 0.35038*width, y: 0.1543880142*height))
        path.addLine(to: CGPoint(x: 0.61254*width, y: 0.1543880142*height))
        path.addCurve(to: CGPoint(x: 0.69768*width, y: 0.22248*height), control1: CGPoint(x: 0.65946*width, y: 0.1543880142*height), control2: CGPoint(x: 0.69768*width, y: 0.187911712*height))
        path.addLine(to: CGPoint(x: 0.69768*width, y: 0.46145*height))
        path.addCurve(to: CGPoint(x: 0.55245*width, y: 0.64805*height), control1: CGPoint(x: 0.69768*width, y: 0.54963*height), control2: CGPoint(x: 0.63795*width, y: 0.62634*height))
        path.addLine(to: CGPoint(x: 0.54947*width, y: 0.6488*height))
        path.addLine(to: CGPoint(x: 0.54713*width, y: 0.65083*height))
        path.addCurve(to: CGPoint(x: 0.50493*width, y: 0.66704*height), control1: CGPoint(x: 0.53505*width, y: 0.66144*height), control2: CGPoint(x: 0.52046*width, y: 0.66704*height))
        path.closeSubpath()
        
        return path
    }
}

struct EarsShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height

        // RIGTH
        path.move(to: CGPoint(x: 0.6885*width, y: 0.4798*height))
        path.addCurve(to: CGPoint(x: 0.62796*width, y: 0.41925*height), control1: CGPoint(x: 0.65509*width, y: 0.4798*height), control2: CGPoint(x: 0.62796*width, y: 0.45264*height))
        path.addCurve(to: CGPoint(x: 0.6885*width, y: 0.35868*height), control1: CGPoint(x: 0.62796*width, y: 0.38587*height), control2: CGPoint(x: 0.65512*width, y: 0.35868*height))
        path.addCurve(to: CGPoint(x: 0.74908*width, y: 0.39476*height), control1: CGPoint(x: 0.73895*width, y: 0.35868*height), control2: CGPoint(x: 0.74908*width, y: 0.37248*height))
        path.addCurve(to: CGPoint(x: 0.6885*width, y: 0.4798*height), control1: CGPoint(x: 0.74908*width, y: 0.43108*height), control2: CGPoint(x: 0.71914*width, y: 0.4798*height))
        path.closeSubpath()
                
        // LEFT
        path.move(to: CGPoint(x: 0.32137*width, y: 0.4798*height))
        path.addCurve(to: CGPoint(x: 0.26079*width, y: 0.39474*height), control1: CGPoint(x: 0.29073*width, y: 0.4798*height), control2: CGPoint(x: 0.26079*width, y: 0.43108*height))
        path.addCurve(to: CGPoint(x: 0.32137*width, y: 0.35866*height), control1: CGPoint(x: 0.26079*width, y: 0.37246*height), control2: CGPoint(x: 0.27094*width, y: 0.35866*height))
        path.addCurve(to: CGPoint(x: 0.38191*width, y: 0.41923*height), control1: CGPoint(x: 0.35477*width, y: 0.35866*height), control2: CGPoint(x: 0.38191*width, y: 0.38584*height))
        path.addCurve(to: CGPoint(x: 0.32137*width, y: 0.4798*height), control1: CGPoint(x: 0.38191*width, y: 0.45261*height), control2: CGPoint(x: 0.35477*width, y: 0.4798*height))
        path.closeSubpath()
                
        return path
    }
}

struct HairShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height

        path.move(to: CGPoint(x: 0.69768*width, y: 0.43575*height))
        path.addLine(to: CGPoint(x: 0.69768*width, y: 0.34581*height))
        path.addCurve(to: CGPoint(x: 0.61639*width, y: 0.20027*height), control1: CGPoint(x: 0.69768*width, y: 0.25239*height), control2: CGPoint(x: 0.61973*width, y: 0.20235*height))
        path.addLine(to: CGPoint(x: 0.60616*width, y: 0.19385*height))
        path.addLine(to: CGPoint(x: 0.59912*width, y: 0.20372*height))
        path.addCurve(to: CGPoint(x: 0.43172*width, y: 0.27788*height), control1: CGPoint(x: 0.59694*width, y: 0.20675*height), control2: CGPoint(x: 0.54467*width, y: 0.27788*height))
        path.addCurve(to: CGPoint(x: 0.31222*width, y: 0.37153*height), control1: CGPoint(x: 0.40216*width, y: 0.27788*height), control2: CGPoint(x: 0.31222*width, y: 0.27788*height))
        path.addLine(to: CGPoint(x: 0.31222*width, y: 0.43578*height))
        path.addLine(to: CGPoint(x: 0.30762*width, y: 0.43578*height))
        path.addCurve(to: CGPoint(x: 0.26082*width, y: 0.25105*height), control1: CGPoint(x: 0.29641*width, y: 0.41057*height), control2: CGPoint(x: 0.26082*width, y: 0.32445*height))
        path.addCurve(to: CGPoint(x: 0.49211*width, y: 0.02459*height), control1: CGPoint(x: 0.26082*width, y: 0.11559*height), control2: CGPoint(x: 0.35377*width, y: 0.02459*height))
        path.addCurve(to: CGPoint(x: 0.62161*width, y: 0.09385*height), control1: CGPoint(x: 0.59077*width, y: 0.02459*height), control2: CGPoint(x: 0.6204*width, y: 0.09103*height))
        path.addLine(to: CGPoint(x: 0.62497*width, y: 0.10164*height))
        path.addLine(to: CGPoint(x: 0.63343*width, y: 0.10167*height))
        path.addCurve(to: CGPoint(x: 0.74908*width, y: 0.2434*height), control1: CGPoint(x: 0.67637*width, y: 0.10167*height), control2: CGPoint(x: 0.74908*width, y: 0.1315*height))
        path.addCurve(to: CGPoint(x: 0.70184*width, y: 0.43575*height), control1: CGPoint(x: 0.74908*width, y: 0.31075*height), control2: CGPoint(x: 0.71292*width, y: 0.40771*height))
        path.addLine(to: CGPoint(x: 0.69768*width, y: 0.43575*height))
        path.closeSubpath()
                    
        return path
    }
}

struct HairGirlShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height

        path.move(to: CGPoint(x: 0.69856*width, y: 0.65546*height))
        path.addCurve(to: CGPoint(x: 0.5965*width, y: 0.61996*height), control1: CGPoint(x: 0.65649*width, y: 0.65546*height), control2: CGPoint(x: 0.61711*width, y: 0.63366*height))
        path.addCurve(to: CGPoint(x: 0.6627*width, y: 0.49154*height), control1: CGPoint(x: 0.62151*width, y: 0.60423*height), control2: CGPoint(x: 0.6627*width, y: 0.56682*height))
        path.addLine(to: CGPoint(x: 0.6627*width, y: 0.3786*height))
        path.addCurve(to: CGPoint(x: 0.61071*width, y: 0.27583*height), control1: CGPoint(x: 0.6627*width, y: 0.32099*height), control2: CGPoint(x: 0.61283*width, y: 0.27765*height))
        path.addLine(to: CGPoint(x: 0.60043*width, y: 0.26703*height))
        path.addLine(to: CGPoint(x: 0.59294*width, y: 0.27834*height))
        path.addCurve(to: CGPoint(x: 0.43396*width, y: 0.36871*height), control1: CGPoint(x: 0.59244*width, y: 0.2791*height), control2: CGPoint(x: 0.5419*width, y: 0.35379*height))
        path.addCurve(to: CGPoint(x: 0.35192*width, y: 0.45546*height), control1: CGPoint(x: 0.37762*width, y: 0.37647*height), control2: CGPoint(x: 0.35192*width, y: 0.41912*height))
        path.addLine(to: CGPoint(x: 0.35192*width, y: 0.49154*height))
        path.addCurve(to: CGPoint(x: 0.41783*width, y: 0.62018*height), control1: CGPoint(x: 0.35192*width, y: 0.56787*height), control2: CGPoint(x: 0.39273*width, y: 0.60471*height))
        path.addCurve(to: CGPoint(x: 0.31606*width, y: 0.65546*height), control1: CGPoint(x: 0.39729*width, y: 0.63387*height), control2: CGPoint(x: 0.35823*width, y: 0.65546*height))
        path.addCurve(to: CGPoint(x: 0.21661*width, y: 0.62001*height), control1: CGPoint(x: 0.27319*width, y: 0.65546*height), control2: CGPoint(x: 0.23521*width, y: 0.63311*height))
        path.addCurve(to: CGPoint(x: 0.27506*width, y: 0.51375*height), control1: CGPoint(x: 0.23767*width, y: 0.60339*height), control2: CGPoint(x: 0.27506*width, y: 0.56646*height))
        path.addCurve(to: CGPoint(x: 0.26641*width, y: 0.44327*height), control1: CGPoint(x: 0.27506*width, y: 0.49156*height), control2: CGPoint(x: 0.27085*width, y: 0.46811*height))
        path.addCurve(to: CGPoint(x: 0.25629*width, y: 0.35663*height), control1: CGPoint(x: 0.26143*width, y: 0.41551*height), control2: CGPoint(x: 0.25629*width, y: 0.38683*height))
        path.addCurve(to: CGPoint(x: 0.49536*width, y: 0.08171*height), control1: CGPoint(x: 0.25629*width, y: 0.15371*height), control2: CGPoint(x: 0.38508*width, y: 0.08171*height))
        path.addCurve(to: CGPoint(x: 0.61592*width, y: 0.1463*height), control1: CGPoint(x: 0.58627*width, y: 0.08171*height), control2: CGPoint(x: 0.61563*width, y: 0.14568*height))
        path.addLine(to: CGPoint(x: 0.61907*width, y: 0.15343*height))
        path.addLine(to: CGPoint(x: 0.62684*width, y: 0.15343*height))
        path.addCurve(to: CGPoint(x: 0.75833*width, y: 0.33273*height), control1: CGPoint(x: 0.71039*width, y: 0.15343*height), control2: CGPoint(x: 0.75833*width, y: 0.21876*height))
        path.addCurve(to: CGPoint(x: 0.74573*width, y: 0.43507*height), control1: CGPoint(x: 0.75833*width, y: 0.36481*height), control2: CGPoint(x: 0.7519*width, y: 0.40052*height))
        path.addCurve(to: CGPoint(x: 0.73442*width, y: 0.52398*height), control1: CGPoint(x: 0.7399*width, y: 0.46741*height), control2: CGPoint(x: 0.73442*width, y: 0.49797*height))
        path.addCurve(to: CGPoint(x: 0.79761*width, y: 0.60241*height), control1: CGPoint(x: 0.73442*width, y: 0.56808*height), control2: CGPoint(x: 0.7693*width, y: 0.59216*height))
        path.addCurve(to: CGPoint(x: 0.69856*width, y: 0.65546*height), control1: CGPoint(x: 0.78068*width, y: 0.6218*height), control2: CGPoint(x: 0.74465*width, y: 0.65546*height))
        path.closeSubpath()
        
        return path
    }
}

struct EyesShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
                
        // Left
        path.move(to: CGPoint(x: 0.41103*width, y: 0.39383*height))
        path.addCurve(to: CGPoint(x: 0.39323*width, y: 0.41162*height), control1: CGPoint(x: 0.4012*width, y: 0.39383*height), control2: CGPoint(x: 0.39323*width, y: 0.40179*height))
        path.addCurve(to: CGPoint(x: 0.41103*width, y: 0.42942*height), control1: CGPoint(x: 0.39323*width, y: 0.42145*height), control2: CGPoint(x: 0.4012*width, y: 0.42942*height))
        path.addCurve(to: CGPoint(x: 0.42882*width, y: 0.41162*height), control1: CGPoint(x: 0.42086*width, y: 0.42942*height), control2: CGPoint(x: 0.42882*width, y: 0.42145*height))
        path.addCurve(to: CGPoint(x: 0.41103*width, y: 0.39383*height), control1: CGPoint(x: 0.42882*width, y: 0.40179*height), control2: CGPoint(x: 0.42086*width, y: 0.39383*height))
        path.closeSubpath()
        
        // Right
        path.move(to: CGPoint(x: 0.58897*width, y: 0.39383*height))
        path.addCurve(to: CGPoint(x: 0.57118*width, y: 0.41162*height), control1: CGPoint(x: 0.57914*width, y: 0.39383*height), control2: CGPoint(x: 0.57118*width, y: 0.40179*height))
        path.addCurve(to: CGPoint(x: 0.58897*width, y: 0.42942*height), control1: CGPoint(x: 0.57118*width, y: 0.42145*height), control2: CGPoint(x: 0.57914*width, y: 0.42942*height))
        path.addCurve(to: CGPoint(x: 0.60677*width, y: 0.41162*height), control1: CGPoint(x: 0.5988*width, y: 0.42942*height), control2: CGPoint(x: 0.60677*width, y: 0.42145*height))
        path.addCurve(to: CGPoint(x: 0.58897*width, y: 0.39383*height), control1: CGPoint(x: 0.60677*width, y: 0.40179*height), control2: CGPoint(x: 0.5988*width, y: 0.39383*height))
        path.closeSubpath()
        
        return path
    }
}

struct SadMouthShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
       
        path.move(to: CGPoint(x: 0.50493*width, y: 0.53599*height))
        path.addCurve(to: CGPoint(x: 0.44565*width, y: 0.5531*height), control1: CGPoint(x: 0.48387*width, y: 0.53599*height), control2: CGPoint(x: 0.46337*width, y: 0.5419*height))
        path.addCurve(to: CGPoint(x: 0.44317*width, y: 0.56405*height), control1: CGPoint(x: 0.44194*width, y: 0.55544*height), control2: CGPoint(x: 0.44083*width, y: 0.56035*height))
        path.addCurve(to: CGPoint(x: 0.45413*width, y: 0.56653*height), control1: CGPoint(x: 0.44552*width, y: 0.56776*height), control2: CGPoint(x: 0.45042*width, y: 0.56886*height))
        path.addCurve(to: CGPoint(x: 0.55574*width, y: 0.56653*height), control1: CGPoint(x: 0.48449*width, y: 0.54735*height), control2: CGPoint(x: 0.52538*width, y: 0.54735*height))
        path.addCurve(to: CGPoint(x: 0.5667*width, y: 0.56405*height), control1: CGPoint(x: 0.55945*width, y: 0.56886*height), control2: CGPoint(x: 0.56435*width, y: 0.56776*height))
        path.addCurve(to: CGPoint(x: 0.56422*width, y: 0.5531*height), control1: CGPoint(x: 0.56904*width, y: 0.56034*height), control2: CGPoint(x: 0.56793*width, y: 0.55544*height))
        path.addCurve(to: CGPoint(x: 0.50493*width, y: 0.53599*height), control1: CGPoint(x: 0.5465*width, y: 0.5419*height), control2: CGPoint(x: 0.526*width, y: 0.53599*height))
        path.closeSubpath()
        
        return path
    }
}

struct NeckShadowShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
 
        path.move(to: CGPoint(x: 0.3689*width, y: 0.63376*height))
        path.addCurve(to: CGPoint(x: 0.45429*width, y: 0.67905*height), control1: CGPoint(x: 0.39301*width, y: 0.65506*height), control2: CGPoint(x: 0.4221*width, y: 0.67088*height))
        path.addCurve(to: CGPoint(x: 0.50494*width, y: 0.69846*height), control1: CGPoint(x: 0.46785*width, y: 0.69097*height), control2: CGPoint(x: 0.48546*width, y: 0.69846*height))
        path.addCurve(to: CGPoint(x: 0.5556*width, y: 0.67905*height), control1: CGPoint(x: 0.52442*width, y: 0.69846*height), control2: CGPoint(x: 0.54203*width, y: 0.69097*height))
        path.addCurve(to: CGPoint(x: 0.64096*width, y: 0.63376*height), control1: CGPoint(x: 0.58778*width, y: 0.67088*height), control2: CGPoint(x: 0.61685*width, y: 0.65505*height))
        path.addCurve(to: CGPoint(x: 0.59952*width, y: 0.63376*height), control1: CGPoint(x: 0.62652*width, y: 0.63376*height), control2: CGPoint(x: 0.61461*width, y: 0.63376*height))
        path.addCurve(to: CGPoint(x: 0.54926*width, y: 0.65512*height), control1: CGPoint(x: 0.58424*width, y: 0.6432*height), control2: CGPoint(x: 0.5674*width, y: 0.65051*height))
        path.addLine(to: CGPoint(x: 0.54327*width, y: 0.65665*height))
        path.addLine(to: CGPoint(x: 0.53863*width, y: 0.66074*height))
        path.addCurve(to: CGPoint(x: 0.51584*width, y: 0.67252*height), control1: CGPoint(x: 0.53357*width, y: 0.66519*height), control2: CGPoint(x: 0.52593*width, y: 0.67025*height))
        path.addCurve(to: CGPoint(x: 0.50494*width, y: 0.67374*height), control1: CGPoint(x: 0.51248*width, y: 0.67327*height), control2: CGPoint(x: 0.50885*width, y: 0.67374*height))
        path.addCurve(to: CGPoint(x: 0.47125*width, y: 0.66074*height), control1: CGPoint(x: 0.48932*width, y: 0.67374*height), control2: CGPoint(x: 0.47801*width, y: 0.66667*height))
        path.addLine(to: CGPoint(x: 0.46658*width, y: 0.65665*height))
        path.addLine(to: CGPoint(x: 0.4606*width, y: 0.65512*height))
        path.addCurve(to: CGPoint(x: 0.41037*width, y: 0.63376*height), control1: CGPoint(x: 0.44246*width, y: 0.65051*height), control2: CGPoint(x: 0.42564*width, y: 0.64319*height))
        path.addCurve(to: CGPoint(x: 0.3689*width, y: 0.63376*height), control1: CGPoint(x: 0.39598*width, y: 0.63376*height), control2: CGPoint(x: 0.38231*width, y: 0.63376*height))
        path.closeSubpath()
        
        return path
    }
}
