import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';

enum LoginState {
  loggedIn,
  loggedOut,
  loading,
}

class UserProfileDropdownItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  UserProfileDropdownItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

class UserProfileButton extends StatefulWidget {
  final String? userName;
  final String? email;
  final String? avatarUrl;
  final VoidCallback? onPressed;
  final LoginState loginState;
  final bool isTestMode;
  final bool testDarkMode;
  final List<UserProfileDropdownItem>? dropdownItems;

  const UserProfileButton({
    super.key,
    this.userName,
    this.email,
    this.avatarUrl,
    this.onPressed,
    this.loginState = LoginState.loggedIn,
    this.isTestMode = false,
    this.testDarkMode = false,
    this.dropdownItems,
  });

  @override
  State<UserProfileButton> createState() => _UserProfileButtonState();
}

class _UserProfileButtonState extends State<UserProfileButton> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isDropdownOpen = false;

  @override
  void dispose() {
    _removeDropdown();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _removeDropdown();
    } else {
      _showDropdown();
    }
    setState(() {
      _isDropdownOpen = !_isDropdownOpen;
    });
  }

  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showDropdown() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        bool isDarkMode;
        if (widget.isTestMode) {
          isDarkMode = widget.testDarkMode;
        } else {
          try {
            isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
          } catch (e) {
            isDarkMode = Theme.of(context).brightness == Brightness.dark;
          }
        }
        
        final ThemeColorSet colors = isDarkMode ? AppColors.dark : AppColors.light;

        return Positioned(
          width: 200,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, size.height + 4),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              color: colors.cardBg,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.dropdownItems != null)
                      ...widget.dropdownItems!.map((item) => _buildDropdownItem(item, colors)),
                    if (widget.dropdownItems == null || widget.dropdownItems!.isEmpty)
                      ..._getDefaultDropdownItems(colors),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  List<Widget> _getDefaultDropdownItems(ThemeColorSet colors) {
    return [
      _buildDropdownItem(
        UserProfileDropdownItem(
          icon: Icons.settings,
          label: 'Settings',
          onTap: () {
            _removeDropdown();
            setState(() {
              _isDropdownOpen = false;
            });
          },
        ),
        colors,
      ),
      _buildDropdownItem(
        UserProfileDropdownItem(
          icon: Icons.dark_mode,
          label: 'Dark mode',
          onTap: () {
            _removeDropdown();
            setState(() {
              _isDropdownOpen = false;
            });
          },
        ),
        colors,
      ),
      _buildDropdownItem(
        UserProfileDropdownItem(
          icon: Icons.logout,
          label: 'Logout',
          onTap: () {
            _removeDropdown();
            setState(() {
              _isDropdownOpen = false;
            });
          },
        ),
        colors,
      ),
    ];
  }

  Widget _buildDropdownItem(UserProfileDropdownItem item, ThemeColorSet colors) {
    return InkWell(
      onTap: () {
        item.onTap();
        _removeDropdown();
        setState(() {
          _isDropdownOpen = false;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Icon(
              item.icon,
              size: 20,
              color: colors.textColor,
            ),
            const SizedBox(width: 12),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 14,
                color: colors.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode;
    if (widget.isTestMode) {
      isDarkMode = widget.testDarkMode;
    } else {
      try {
        isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
      } catch (e) {
        isDarkMode = Theme.of(context).brightness == Brightness.dark;
      }
    }
    
    final ThemeColorSet colors = isDarkMode ? AppColors.dark : AppColors.light;

    return CompositedTransformTarget(
      link: _layerLink,
      child: _buildButton(colors),
    );
  }

  Widget _buildButton(ThemeColorSet colors) {
    switch (widget.loginState) {
      case LoginState.loggedIn:
        return _buildLoggedInButton(colors);
      case LoginState.loggedOut:
        return _buildLoggedOutButton(colors);
      case LoginState.loading:
        return _buildLoadingButton(colors);
    }
  }

  Widget _buildLoggedInButton(ThemeColorSet colors) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: _isDropdownOpen ? colors.accentColor : Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (widget.onPressed != null) {
              widget.onPressed!();
            } else {
              _toggleDropdown();
            }
          },
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 4.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAvatar(),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.userName ?? 'User',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: colors.textColor,
                      ),
                    ),
                    if (widget.email != null)
                      Text(
                        widget.email!,
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textMuted,
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 4),
                Icon(
                  _isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: colors.textMuted,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoggedOutButton(ThemeColorSet colors) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onPressed,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 8.0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.login,
                size: 18,
                color: colors.textColor,
              ),
              const SizedBox(width: 8),
              Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colors.textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingButton(ThemeColorSet colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 8.0,
      ),
      child: SizedBox(
        width: 100,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(colors.accentColor),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Loading...',
              style: TextStyle(
                fontSize: 14,
                color: colors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    if (widget.avatarUrl != null) {
      return CircleAvatar(
        radius: 16,
        backgroundImage: NetworkImage(widget.avatarUrl!),
      );
    } else {
      return CircleAvatar(
        radius: 16,
        backgroundColor: Colors.grey[300],
        child: Text(
          _getInitials(),
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }

  String _getInitials() {
    if (widget.userName == null || widget.userName!.isEmpty) {
      return 'U';
    }

    final parts = widget.userName!.trim().split(' ');
    if (parts.length > 1) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    } else {
      return parts.first[0].toUpperCase();
    }
  }
} 