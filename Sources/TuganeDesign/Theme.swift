//
//  Theme.swift
//  TuganeDesign: the shared design language for tugane's apps.
//
//  Extracted from Auger's v2 design system (auger-app/Auger/V2/Theme.swift)
//  so every app renders from the same tokens. The design toggles dark/light
//  in-app, so every colour is resolved from an explicit `Palette` (never a
//  system semantic colour) and pushed through the environment.
//

import SwiftUI

// MARK: - Theme

public enum Theme: String, CaseIterable, Sendable {
    case dark, light

    public var toggled: Theme { self == .dark ? .light : .dark }

    /// Label shown on a toolbar toggle; names the theme you'd switch to.
    public var toggleLabel: String { self == .dark ? "Light" : "Dark" }

    public var colorScheme: ColorScheme { self == .dark ? .dark : .light }

    public var palette: Palette { self == .dark ? .dark : .light }
}

// MARK: - Palette

/// One resolved set of colours. Mirrors Auger's `:root` / `[data-theme]`
/// blocks 1:1.
public struct Palette: Sendable {
    public let win: Color
    public let sidebar: Color
    public let content: Color

    public let card: Color
    public let cardHover: Color
    public let well: Color

    public let sep: Color
    public let sep2: Color

    public let label: Color
    public let label2: Color
    public let label3: Color

    public let btn: Color
    public let btnHover: Color

    public let accent: Color
    public let accentHover: Color
    public let accentTint: Color

    public let red: Color
    public let redHover: Color
    public let green: Color
    public let amber: Color
    /// Distinct from `amber` in BOTH palettes. Light-mode amber is already an
    /// orange, so a state needing its own orange must use this.
    public let orange: Color

    /// Status colours darkened for small text. The vivid `green/amber/orange/red`
    /// are icon/fill colours: at caption sizes on a light card they fall to
    /// ~2:1 contrast. Use these whenever a status colour carries *text*.
    public let greenText: Color
    public let amberText: Color
    public let orangeText: Color
    public let redText: Color

    public let sheet: Color
    public let scrim: Color

    /// True for the dark palette. Lets views tune effects that don't translate
    /// (glows, shadows) without reaching for the environment's colorScheme,
    /// which the in-app theme toggle can disagree with.
    public let isDark: Bool

    /// Dark palettes carry the vivid glow; light ones smear unless dialed back.
    public var glowStrength: Double { isDark ? 1.0 : 0.4 }

    public static let dark = Palette(
        win: Color(hex: 0x1C1C1E),
        sidebar: Color(hex: 0x262628, opacity: 0.72),
        content: Color(hex: 0x1C1C1E),
        card: Color(hex: 0x2C2C2E),
        cardHover: Color(hex: 0x333335),
        well: Color(hex: 0x242426),
        sep: Color(white: 1, opacity: 0.09),
        sep2: Color(white: 1, opacity: 0.055),
        label: Color(hex: 0xFFFFFF),
        label2: Color(white: 1, opacity: 0.66),
        label3: Color(white: 1, opacity: 0.56),
        btn: Color(white: 1, opacity: 0.11),
        btnHover: Color(white: 1, opacity: 0.17),
        accent: Color(hex: 0x0A84FF),
        accentHover: Color(hex: 0x3D9DFF),
        accentTint: Color(hex: 0x0A84FF, opacity: 0.16),
        red: Color(hex: 0xFF453A),
        redHover: Color(hex: 0xFF6259),
        green: Color(hex: 0x30D158),
        amber: Color(hex: 0xFFD60A),
        orange: Color(hex: 0xFF9F0A),
        greenText: Color(hex: 0x30D158),
        amberText: Color(hex: 0xFFD60A),
        orangeText: Color(hex: 0xFF9F0A),
        redText: Color(hex: 0xFF453A),
        sheet: Color(hex: 0x3A3A3C),
        scrim: Color(black: 0, opacity: 0.42),
        isDark: true
    )

    public static let light = Palette(
        win: Color(hex: 0xFFFFFF),
        sidebar: Color(hex: 0xF6F6F8, opacity: 0.80),
        content: Color(hex: 0xFFFFFF),
        card: Color(hex: 0xF5F5F7),
        cardHover: Color(hex: 0xEEEEF1),
        well: Color(hex: 0xFAFAFC),
        sep: Color(white: 0, opacity: 0.09),
        sep2: Color(white: 0, opacity: 0.055),
        label: Color(hex: 0x000000),
        label2: Color(white: 0, opacity: 0.64),
        label3: Color(white: 0, opacity: 0.58),
        btn: Color(white: 0, opacity: 0.06),
        btnHover: Color(white: 0, opacity: 0.10),
        accent: Color(hex: 0x007AFF),
        accentHover: Color(hex: 0x0A6FE0),
        accentTint: Color(hex: 0x007AFF, opacity: 0.12),
        red: Color(hex: 0xFF3B30),
        redHover: Color(hex: 0xE32A20),
        green: Color(hex: 0x34C759),
        amber: Color(hex: 0xFF9F0A),
        orange: Color(hex: 0xC93400),
        greenText: Color(hex: 0x1F8A3D),
        amberText: Color(hex: 0xB36200),
        orangeText: Color(hex: 0xC93400),
        redText: Color(hex: 0xD70015),
        sheet: Color(hex: 0xF2F2F5),
        scrim: Color(black: 0, opacity: 0.24),
        isDark: false
    )

    public init(win: Color, sidebar: Color, content: Color, card: Color, cardHover: Color,
                well: Color, sep: Color, sep2: Color, label: Color, label2: Color,
                label3: Color, btn: Color, btnHover: Color, accent: Color,
                accentHover: Color, accentTint: Color, red: Color, redHover: Color,
                green: Color, amber: Color, orange: Color, greenText: Color,
                amberText: Color, orangeText: Color, redText: Color,
                sheet: Color, scrim: Color, isDark: Bool) {
        self.win = win; self.sidebar = sidebar; self.content = content
        self.card = card; self.cardHover = cardHover; self.well = well
        self.sep = sep; self.sep2 = sep2
        self.label = label; self.label2 = label2; self.label3 = label3
        self.btn = btn; self.btnHover = btnHover
        self.accent = accent; self.accentHover = accentHover; self.accentTint = accentTint
        self.red = red; self.redHover = redHover; self.green = green
        self.amber = amber; self.orange = orange
        self.greenText = greenText; self.amberText = amberText
        self.orangeText = orangeText; self.redText = redText
        self.sheet = sheet; self.scrim = scrim; self.isDark = isDark
    }
}

// MARK: - Environment plumbing

private struct PaletteKey: EnvironmentKey {
    static let defaultValue = Palette.dark
}

public extension EnvironmentValues {
    var palette: Palette {
        get { self[PaletteKey.self] }
        set { self[PaletteKey.self] = newValue }
    }
}

// MARK: - Color helpers

public extension Color {
    /// 0xRRGGBB literal with optional opacity.
    init(hex: UInt32, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }

    init(white: Double, opacity: Double) {
        self.init(.sRGB, red: white, green: white, blue: white, opacity: opacity)
    }

    init(black: Double, opacity: Double) {
        self.init(.sRGB, red: black, green: black, blue: black, opacity: opacity)
    }
}
