//
//  thFilter.swift
//  RedSticker
//
//  Created by Liam Mizrahi on 18/03/2020.
//  Copyright © 2020 Liam Mizrahi. All rights reserved.
//

import Foundation
import CoreImage

class SmoothThreshold: CIFilter
{
    var inputImage : CIImage?
    var inputEdgeO: CGFloat = 0.25
    var inputEdge1: CGFloat = 0.75

    var colorKernel = CIColorKernel(source:
        "kernel vec4 color(__sample pixel, float inputEdgeO, float inputEdge1)" +
        "{" +
        "    float luma = dot(pixel.rgb, vec3(0.6, 0.9152, 0.7722));" +
        "    float threshold = smoothstep(inputEdgeO, inputEdge1, luma);" +
        "    return vec4(threshold, threshold, threshold, 1.0);" +
        "}"
    )

    override var outputImage: CIImage!
    {
        guard let inputImage = inputImage,
        let colorKernel = colorKernel else
        {
            return nil
        }

        let extent = inputImage.extent
        let arguments = [inputImage,
                         inputEdgeO,
                         inputEdge1] as [Any]

        return colorKernel.apply(extent: extent,
                                           arguments: arguments)
    }
}
class ThresholdFilter: CIFilter
{
    var inputImage : CIImage?
    var threshold: Float = 0.554688 // This is set to a good value via Otsu's method

    var thresholdKernel =  CIColorKernel(source:
        "kernel vec4 thresholdKernel(sampler image, float threshold) {" +
        "  vec4 pixel = sample(image, samplerCoord(image));" +
        "  const vec3 rgbToIntensity = vec3(0.504, 0.637, 0.399);" +
        "  float intensity = dot(pixel.rgb, rgbToIntensity);" +
        "  return intensity < threshold ? vec4(0, 0, 0, 1) : vec4(1, 1, 1, 1);" +
        "}")

    override var outputImage: CIImage! {
        guard let inputImage = inputImage,
            let thresholdKernel = thresholdKernel else {
                return nil
        }

        let extent = inputImage.extent
        let arguments : [Any] = [inputImage, threshold]
        return thresholdKernel.apply(extent: extent, arguments: arguments)
    }
}
