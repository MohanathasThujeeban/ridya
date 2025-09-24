import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class Ridya3DButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final double? width;
  final double? height;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;

  const Ridya3DButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.width,
    this.height = 56,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
  });

  @override
  State<Ridya3DButton> createState() => _Ridya3DButtonState();
}

class _Ridya3DButtonState extends State<Ridya3DButton>
    with TickerProviderStateMixin {
  late AnimationController _pressController;
  late AnimationController _glowController;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      duration: AppTheme.quickAnimation,
      vsync: this,
    );
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pressController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _handleTapDown(),
      onTapUp: (_) => _handleTapUp(),
      onTapCancel: () => _handleTapUp(),
      child: AnimatedBuilder(
        animation: Listenable.merge([_pressController, _glowController]),
        builder: (context, child) {
          final double scale = 1.0 - (_pressController.value * 0.05);
          final double glowIntensity = 0.3 + (_glowController.value * 0.4);

          return Transform.scale(
            scale: scale,
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                borderRadius: AppTheme.buttonRadius,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.backgroundColor ?? AppTheme.primaryOrange,
                    widget.backgroundColor?.withOpacity(0.8) ??
                        AppTheme.darkOrange,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: (widget.backgroundColor ?? AppTheme.primaryOrange)
                        .withOpacity(glowIntensity),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                  if (!_isPressed) ...AppTheme.floatingShadow,
                  if (_isPressed) ...AppTheme.pressedShadow,
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: AppTheme.buttonRadius,
                  onTap: widget.isLoading ? null : widget.onPressed,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.isLoading)
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                widget.textColor ?? AppTheme.primaryWhite,
                              ),
                            ),
                          )
                        else if (widget.icon != null)
                          Icon(
                            widget.icon,
                            color: widget.textColor ?? AppTheme.primaryWhite,
                            size: 20,
                          ),
                        if (widget.icon != null && !widget.isLoading)
                          const SizedBox(width: 8),
                        if (!widget.isLoading)
                          Text(
                            widget.text,
                            style: AppTheme.bodyLarge.copyWith(
                              color: widget.textColor ?? AppTheme.primaryWhite,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleTapDown() {
    setState(() {
      _isPressed = true;
    });
    _pressController.forward();
  }

  void _handleTapUp() {
    setState(() {
      _isPressed = false;
    });
    _pressController.reverse();
  }
}

class Ridya3DCard extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool showGlow;

  const Ridya3DCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.onTap,
    this.showGlow = false,
  });

  @override
  State<Ridya3DCard> createState() => _Ridya3DCardState();
}

class _Ridya3DCardState extends State<Ridya3DCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: AppTheme.mediumAnimation,
      vsync: this,
    );
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    if (widget.showGlow) {
      _glowController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_hoverController, _glowController]),
      builder: (context, child) {
        final double elevation = 4 + (_hoverController.value * 8);
        final double glowIntensity = widget.showGlow
            ? 0.2 + (_glowController.value * 0.3)
            : 0.0;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(_hoverController.value * 0.02)
            ..rotateY(_hoverController.value * 0.01),
          child: Container(
            width: widget.width,
            height: widget.height,
            margin: widget.margin,
            decoration: BoxDecoration(
              borderRadius: AppTheme.cardRadius,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppTheme.lightBlack, AppTheme.primaryBlack],
              ),
              boxShadow: [
                if (widget.showGlow)
                  BoxShadow(
                    color: AppTheme.primaryOrange.withOpacity(glowIntensity),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: elevation * 2,
                  offset: Offset(0, elevation),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: elevation,
                  offset: Offset(0, elevation * 0.5),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: AppTheme.cardRadius,
                onTap: widget.onTap,
                onHover: (hovering) {
                  if (hovering) {
                    _hoverController.forward();
                  } else {
                    _hoverController.reverse();
                  }
                },
                child: Container(padding: widget.padding, child: widget.child),
              ),
            ),
          ),
        );
      },
    );
  }
}

class Ridya3DFloatingActionButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;

  const Ridya3DFloatingActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.backgroundColor,
    this.iconColor,
    this.size = 56.0,
  });

  @override
  State<Ridya3DFloatingActionButton> createState() =>
      _Ridya3DFloatingActionButtonState();
}

class _Ridya3DFloatingActionButtonState
    extends State<Ridya3DFloatingActionButton>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _rotateController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    _rotateController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _floatController,
        _rotateController,
        _pulseController,
      ]),
      builder: (context, child) {
        final double floatOffset = sin(_floatController.value * 2 * pi) * 4;
        final double pulseScale =
            1.0 + (sin(_pulseController.value * 2 * pi) * 0.05);

        return Transform.translate(
          offset: Offset(0, floatOffset),
          child: Transform.scale(
            scale: pulseScale,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateZ(_rotateController.value * 2 * pi),
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.backgroundColor ?? AppTheme.primaryOrange,
                      (widget.backgroundColor ?? AppTheme.primaryOrange)
                          .withOpacity(0.8),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (widget.backgroundColor ?? AppTheme.primaryOrange)
                          .withOpacity(0.4),
                      blurRadius: 15,
                      spreadRadius: 3,
                      offset: const Offset(0, 6),
                    ),
                    ...AppTheme.floatingShadow,
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(widget.size / 2),
                    onTap: widget.onPressed,
                    child: Icon(
                      widget.icon,
                      color: widget.iconColor ?? AppTheme.primaryWhite,
                      size: widget.size * 0.4,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class Ridya3DTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const Ridya3DTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  State<Ridya3DTextField> createState() => _Ridya3DTextFieldState();
}

class _Ridya3DTextFieldState extends State<Ridya3DTextField>
    with TickerProviderStateMixin {
  late AnimationController _focusController;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusController = AnimationController(
      duration: AppTheme.mediumAnimation,
      vsync: this,
    );
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });

      if (_isFocused) {
        _focusController.forward();
      } else {
        _focusController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _focusController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _focusController,
      builder: (context, child) {
        final double elevation = 2 + (_focusController.value * 6);
        final double glowIntensity = _focusController.value * 0.3;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(_focusController.value * 0.01),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: AppTheme.inputRadius,
              boxShadow: [
                if (_isFocused)
                  BoxShadow(
                    color: AppTheme.primaryOrange.withOpacity(glowIntensity),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: elevation * 2,
                  offset: Offset(0, elevation),
                ),
              ],
            ),
            child: TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              validator: widget.validator,
              style: AppTheme.bodyMedium,
              decoration: InputDecoration(
                labelText: widget.label,
                hintText: widget.hintText,
                prefixIcon: widget.prefixIcon != null
                    ? Icon(
                        widget.prefixIcon,
                        color: _isFocused
                            ? AppTheme.primaryOrange
                            : AppTheme.darkGrey,
                      )
                    : null,
                suffixIcon: widget.suffixIcon != null
                    ? IconButton(
                        icon: Icon(
                          widget.suffixIcon,
                          color: _isFocused
                              ? AppTheme.primaryOrange
                              : AppTheme.darkGrey,
                        ),
                        onPressed: widget.onSuffixTap,
                      )
                    : null,
                filled: true,
                fillColor: AppTheme.lightBlack,
                border: OutlineInputBorder(
                  borderRadius: AppTheme.inputRadius,
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppTheme.inputRadius,
                  borderSide: const BorderSide(
                    color: AppTheme.primaryOrange,
                    width: 2,
                  ),
                ),
                labelStyle: AppTheme.bodyMedium.copyWith(
                  color: _isFocused
                      ? AppTheme.primaryOrange
                      : AppTheme.darkGrey,
                ),
                hintStyle: AppTheme.bodySmall,
              ),
            ),
          ),
        );
      },
    );
  }
}
