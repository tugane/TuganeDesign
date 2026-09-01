//
//  Noise.swift
//  TuganeDesign
//
//  A subtle film-grain overlay tiled across the whole window. The texture is
//  generated once and cached; it renders with a low-opacity soft-light blend so
//  it adds tooth without hurting legibility, in both light and dark.
//
//  Ported from Auger's V2/Noise.swift — the grain is part of the language, not
//  an Auger-only flourish.
//

import SwiftUI
import CoreGraphics

public enum NoiseTexture {
    public static let image: NSImage = generate()

    private static func generate(size: Int = 140) -> NSImage {
        let bytesPerRow = size * 4
        var pixels = [UInt8](repeating: 0, count: bytesPerRow * size)
        for i in stride(from: 0, to: pixels.count, by: 4) {
            let v = UInt8.random(in: 0...255)   // monochrome grain
            pixels[i] = v; pixels[i + 1] = v; pixels[i + 2] = v; pixels[i + 3] = 255
        }
        let cs = CGColorSpaceCreateDeviceRGB()
        let cg = pixels.withUnsafeMutableBytes { buf -> CGImage? in
            CGContext(data: buf.baseAddress, width: size, height: size,
                      bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: cs,
                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)?.makeImage()
        }
        let img = NSImage(size: NSSize(width: size, height: size))
        if let cg { img.addRepresentation(NSBitmapImageRep(cgImage: cg)) }
        return img
    }
}

public struct NoiseOverlay: View {
    public var opacity: Double

    public init(opacity: Double = 0.20) { self.opacity = opacity }

    public var body: some View {
        Image(nsImage: NoiseTexture.image)
            .resizable(resizingMode: .tile)
            .opacity(opacity)
            .blendMode(.softLight)   // shows on dark and light without crushing legibility
            .allowsHitTesting(false)
            .ignoresSafeArea()
    }
}
