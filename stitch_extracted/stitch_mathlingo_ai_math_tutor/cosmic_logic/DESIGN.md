---
name: Cosmic Logic
colors:
  surface: '#101126'
  surface-dim: '#101126'
  surface-bright: '#36374e'
  surface-container-lowest: '#0b0c21'
  surface-container-low: '#191a2f'
  surface-container: '#1d1e33'
  surface-container-high: '#27283e'
  surface-container-highest: '#32334a'
  on-surface: '#e1e0fe'
  on-surface-variant: '#d4c0d7'
  inverse-surface: '#e1e0fe'
  inverse-on-surface: '#2e2e45'
  outline: '#9d8ba0'
  outline-variant: '#504254'
  surface-tint: '#ebb2ff'
  primary: '#ebb2ff'
  on-primary: '#520072'
  primary-container: '#bc13fe'
  on-primary-container: '#ffffff'
  inverse-primary: '#9800d0'
  secondary: '#d3fbff'
  on-secondary: '#00363a'
  secondary-container: '#00eefc'
  on-secondary-container: '#00686f'
  tertiary: '#fface8'
  on-tertiary: '#5e0053'
  tertiary-container: '#d700c1'
  on-tertiary-container: '#ffffff'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#f8d8ff'
  primary-fixed-dim: '#ebb2ff'
  on-primary-fixed: '#320047'
  on-primary-fixed-variant: '#74009f'
  secondary-fixed: '#7df4ff'
  secondary-fixed-dim: '#00dbe9'
  on-secondary-fixed: '#002022'
  on-secondary-fixed-variant: '#004f54'
  tertiary-fixed: '#ffd7f0'
  tertiary-fixed-dim: '#fface8'
  on-tertiary-fixed: '#3a0033'
  on-tertiary-fixed-variant: '#840076'
  background: '#101126'
  on-background: '#e1e0fe'
  surface-variant: '#32334a'
typography:
  headline-lg:
    fontFamily: Space Grotesk
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Space Grotesk
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: -0.01em
  body-lg:
    fontFamily: Lexend
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Lexend
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-lg:
    fontFamily: Lexend
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
  label-sm:
    fontFamily: Lexend
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
rounded:
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
  full: 9999px
spacing:
  unit: 8px
  margin-mobile: 24px
  gutter: 16px
  container-padding: 16px
  stack-sm: 8px
  stack-md: 16px
  stack-lg: 32px
---

## Brand & Style
The brand personality is high-energy, intellectual, and explorative. It aims to transform the perceived "dryness" of mathematics into a vibrant, gamified journey through a digital cosmos. The target audience is modern learners who resonate with high-fidelity, dark-themed interfaces commonly found in gaming and premium fintech.

The design style is a synthesis of **Glassmorphism** and **Futuristic Minimalism**. It utilizes deep spatial depth, translucent layers, and neon accents to evoke a sense of advanced technology. The emotional response is one of curiosity and empowerment ("Sfida e Ditës"), making the user feel like they are piloting a sophisticated learning vessel rather than sitting in a traditional classroom.

## Colors
The palette is anchored by **Deep Space-Indigo**, providing a low-fatigue environment for extended study sessions. **Neon-Electric-Purple** serves as the primary driver for action, used for buttons and critical interactive states.

To enhance the futuristic feel, a secondary **Neon Cyan** is used for progress indicators and "correct" states (e.g., "Saktë!"), while a **Vibrant Magenta** is reserved for rewards and streaks. Gradients should be used sparingly but boldly on primary surfaces to create a sense of light-emission within the dark interface.

## Typography
This design system utilizes a dual-font strategy. **Space Grotesk** is used for headlines, numbers, and mathematical equations, providing a technical, cutting-edge aesthetic that aligns with the futuristic theme. 

**Lexend** is employed for all body copy and UI labels. Its specific design for readability and educational contexts ensures that Albanian text like "Mësimet e fundit" or "Vazhdo Progresin" remains exceptionally clear. Numerical data within body text should inherit the tabular lining properties of Lexend to ensure vertical alignment in mathematical lists.

## Layout & Spacing
Following Material Design 3 principles, the system uses an **8dp linear scale** for all spacing and dimensions. The mobile layout is built on a **4-column fluid grid** with 24px outer margins to provide "breathing room" against the dark background.

Vertical rhythm is maintained through standardized stack spacing. Use `stack-md` (16px) for related elements within a card and `stack-lg` (32px) to separate distinct content sections like "Sfida e Ditës" and "Kategoritë".

## Elevation & Depth
Depth is created through **Glassmorphism** rather than traditional elevation shadows. Surfaces use a semi-transparent fill (White at 5-10% opacity) with a heavy **Backdrop Blur** (20px to 40px). 

To define these layers, each glass card must have a 1px inner border (stroke) with a linear gradient from White (20% opacity) to White (0% opacity) to simulate light hitting the edge of the glass. Soft, diffused drop shadows are tinted with the Primary Neon-Purple (`#BC13FE`) at very low opacity (10-15%) to create a "glow" effect on floating elements like the primary "Vazhdo" (Continue) button.

## Shapes
The shape language is friendly and organic to balance the sharp, futuristic colors. High roundedness (`level 3`) is applied across the system. Standard containers and cards use a 2rem (32px) corner radius, while smaller interactive elements like chips and input fields use pill-shaped (fully rounded) corners. This "softness" makes the mathematical challenges feel approachable and less intimidating.

## Components
- **Buttons**: Primary buttons are pill-shaped with the `accent_gradient`. They utilize a subtle outer glow (0px 4px 20px) matching the primary color. Text is white and bold.
- **Glass Cards**: Used for "Mësime" (Lessons). They feature a 1px translucent border and a heavy blur. Content inside should have high contrast against the blurred background.
- **Progress Bars**: Tracked using a Neon Cyan (`#00F0FF`) fill against a dark indigo track. The "cap" of the progress bar should have a small glow point to indicate the current "Progresi".
- **Chips**: Used for categories or difficulty levels. These are outlined with a 1.5px stroke of the primary color, with no fill unless selected.
- **Input Fields**: Minimalist design with a focus state that triggers a 1px neon-purple border and a soft inner glow, ensuring the user knows exactly where they are entering their math answers.
- **Gamification Elements**: Streak counters and "Shpërblimet" (Rewards) use the Vibrant Magenta gradient to differentiate them from standard educational content.