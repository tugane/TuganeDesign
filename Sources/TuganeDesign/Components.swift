//
//  Components.swift
//  TuganeDesign — shared building blocks, extracted from Auger's v2 system.
//
//  Pill buttons, text links, hover fills, pointer cursors, the card container,
//  disclosure chevron, checkbox, and the icon-badge mascot. Every clickable
//  control shows the pointing-hand cursor — that's part of the language.
//

import SwiftUI
import AppKit

// MARK: - Hover cursor

private struct HoverCursor: ViewModifier {
    let cursor: NSCursor
    @State private var pushed = false
    func body(content: Content) -> some View {
        content
            .onHover { inside in
                if inside {
                    if !pushed { cursor.push(); pushed = true }
                } else if pushed {
                    NSCursor.pop(); pushed = false
                }
            }
            .onDisappear { if pushed { NSCursor.pop(); pushed = false } }
    }
}

public extension View {
    /// Show the given cursor (pointing hand by default) while hovering.
    func hoverCursor(_ cursor: NSCursor = .pointingHand) -> some View {
        modifier(HoverCursor(cursor: cursor))
    }
}

// MARK: - Pointer button style

/// Borderless button that shows the pointing-hand cursor on hover while
/// enabled. Prefer over `.plain` for anything clickable.
public struct PointerButtonStyle: ButtonStyle {
    public init() {}
    public func makeBody(configuration: Configuration) -> some View {
        PointerButtonBody(configuration: configuration)
    }
}

private struct PointerButtonBody: View {
    let configuration: ButtonStyleConfiguration
    @Environment(\.isEnabled) private var isEnabled
    var body: some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.72 : 1)
            .hoverCursor(isEnabled ? .pointingHand : .arrow)
    }
}

public extension ButtonStyle where Self == PointerButtonStyle {
    static var pointer: PointerButtonStyle { PointerButtonStyle() }
}

// MARK: - Hover fill

private struct HoverFill: ViewModifier {
    let base: Color
    let hover: Color
    let radius: CGFloat
    @State private var hovering = false
    func body(content: Content) -> some View {
        content
            .background(RoundedRectangle(cornerRadius: radius, style: .continuous).fill(hovering ? hover : base))
            .onHover { hovering = $0 }
    }
}

public extension View {
    func hoverFill(_ base: Color, _ hover: Color, radius: CGFloat = 0) -> some View {
        modifier(HoverFill(base: base, hover: hover, radius: radius))
    }
}

// MARK: - Pill button

public enum PillRole { case accent, neutral, destructive }

public struct PillButton: View {
    let title: String
    var role: PillRole
    var height: CGFloat
    var hpad: CGFloat
    var radius: CGFloat
    var font: Font
    let action: () -> Void

    @Environment(\.palette) private var p
    @State private var hovering = false

    public init(_ title: String,
                role: PillRole = .neutral,
                height: CGFloat = 36,
                hpad: CGFloat = 18,
                radius: CGFloat = 9,
                font: Font = .system(size: 13.5, weight: .medium),
                action: @escaping () -> Void) {
        self.title = title
        self.role = role
        self.height = height
        self.hpad = hpad
        self.radius = radius
        self.font = font
        self.action = action
    }

    private var fill: Color {
        switch role {
        case .accent: hovering ? p.accentHover : p.accent
        case .neutral: hovering ? p.btnHover : p.btn
        case .destructive: hovering ? p.redHover : p.red
        }
    }
    private var fg: Color { role == .neutral ? p.label : .white }

    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(font)
                .foregroundStyle(fg)
                .frame(height: height)
                .padding(.horizontal, hpad)
                .background(RoundedRectangle(cornerRadius: radius, style: .continuous).fill(fill))
                .contentShape(Rectangle())
        }
        .buttonStyle(.pointer)
        .onHover { hovering = $0 }
    }
}

// MARK: - Text link

public struct LinkButton: View {
    let title: String
    var color: Color
    var hoverColor: Color?
    var font: Font
    let action: () -> Void
    @State private var hovering = false

    public init(_ title: String, color: Color, hoverColor: Color? = nil,
                font: Font = .system(size: 13, weight: .medium),
                action: @escaping () -> Void) {
        self.title = title
        self.color = color
        self.hoverColor = hoverColor
        self.font = font
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(title).font(font).foregroundStyle(hovering ? (hoverColor ?? color) : color)
        }
        .buttonStyle(.pointer)
        .onHover { hovering = $0 }
    }
}

// MARK: - Checkbox

public struct CheckBox: View {
    let on: Bool
    @Environment(\.palette) private var p

    public init(on: Bool) { self.on = on }

    public var body: some View {
        RoundedRectangle(cornerRadius: 5, style: .continuous)
            .fill(on ? p.accent : .clear)
            .frame(width: 19, height: 19)
            .overlay(
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .strokeBorder(on ? p.accent : p.label3, lineWidth: 1.4)
            )
            .overlay(
                Image(systemName: "checkmark")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(.white)
                    .opacity(on ? 1 : 0)
            )
            .contentShape(Rectangle())
            .accessibilityHidden(true)
    }
}

// MARK: - Disclosure chevron

public struct Chevron: View {
    var open: Bool
    var size: CGFloat
    var color: Color

    public init(open: Bool = false, size: CGFloat = 14, color: Color) {
        self.open = open
        self.size = size
        self.color = color
    }

    public var body: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: size, weight: .semibold))
            .foregroundStyle(color)
            .rotationEffect(.degrees(open ? 90 : 0))
            .accessibilityHidden(true)
    }
}

// MARK: - Card background

public extension View {
    /// Container surface, a solid rounded panel filled with the given token.
    /// Clips content so row hover fills and separators can't paint corners.
    func card(_ color: Color, radius: CGFloat = 12) -> some View {
        background(RoundedRectangle(cornerRadius: radius, style: .continuous).fill(color))
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
    }
}

// MARK: - Icon badge (Auger's mascot spot)

/// A clean SF Symbol in a soft tinted circle, for hero/empty/error/sheet spots.
public struct Mascot: View {
    let symbol: String
    var tint: Color?

    @Environment(\.palette) private var p

    public init(symbol: String, tint: Color? = nil) {
        self.symbol = symbol
        self.tint = tint
    }

    public var body: some View {
        GeometryReader { geo in
            let s = min(geo.size.width, geo.size.height)
            let color = tint ?? p.accent
            ZStack {
                Circle().fill(color.opacity(0.16))
                Image(systemName: symbol)
                    .font(.system(size: s * 0.42, weight: .medium))
                    .foregroundStyle(color)
            }
            .frame(width: s, height: s)
            .position(x: geo.size.width / 2, y: geo.size.height / 2)
        }
    }
}
