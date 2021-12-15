import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformIcons {
  bool isMaterial(BuildContext context) =>
      Theme.of(context).platform == TargetPlatform.android;

  PlatformIcons(this.context);

  final BuildContext context;

  /// Icons: Icons.clear : CupertinoIcons.clear
  IconData get clear =>
      isMaterial(context) ? Icons.clear : CupertinoIcons.clear;

  /// Icons: Icons.create : CupertinoIcons.create
  IconData get create =>
      isMaterial(context) ? Icons.edit : CupertinoIcons.create;

  /// Icons: Icons.arrow_forward : CupertinoIcons.forward
  IconData get forward =>
      isMaterial(context) ? Icons.arrow_forward : CupertinoIcons.forward;

  /// Icons: Icons.favorite : CupertinoIcons.heart_solid
  IconData get heartSolid =>
      isMaterial(context) ? Icons.favorite : CupertinoIcons.heart_solid;

  IconData get heartOutlined =>
      isMaterial(context) ? Icons.favorite_outline : CupertinoIcons.heart;

  /// Icons: Icons.helOutline : CupertinoIcons.(custom)
  IconData get helpOutline => isMaterial(context)
      ? Icons.help_outline
      : const IconData(
          0xf445,
          fontFamily: 'CupertinoIcons',
          fontPackage: 'cupertino_icons',
        );

  /// Icons: Icons.info : CupertinoIcons.info
  IconData get info => isMaterial(context) ? Icons.info : CupertinoIcons.info;

  /// Icons: Icons.chevron_left : CupertinoIcons.left_chevron
  IconData get leftChevron =>
      isMaterial(context) ? Icons.chevron_left : CupertinoIcons.left_chevron;

  /// Icons: Icons.location_on : CupertinoIcons.location
  IconData get location =>
      isMaterial(context) ? Icons.location_on : CupertinoIcons.location;

  /// Icons: Icons.location_on : CupertinoIcons.location_solid
  IconData get locationSolid =>
      isMaterial(context) ? Icons.location_on : CupertinoIcons.location_solid;

  /// Icons: Icons.mail : CupertinoIcons.mail
  IconData get mail => isMaterial(context) ? Icons.mail : CupertinoIcons.mail;

  /// Icons: Icons.mail : CupertinoIcons.mail_solid
  IconData get mailSolid =>
      isMaterial(context) ? Icons.mail : CupertinoIcons.mail_solid;

  /// Icons: Icons.refresh : CupertinoIcons.refresh
  IconData get refresh =>
      isMaterial(context) ? Icons.refresh : CupertinoIcons.refresh;

  /// Icons: Icons.refresh : CupertinoIcons.refresh_bold
  IconData get refreshBold =>
      isMaterial(context) ? Icons.refresh : CupertinoIcons.refresh_bold;

  /// Icons: Icons.chevron_right : CupertinoIcons.right_chevron
  IconData get rightChevron =>
      isMaterial(context) ? Icons.chevron_right : CupertinoIcons.right_chevron;

  /// Icons: Icons.search : CupertinoIcons.search
  IconData get search =>
      isMaterial(context) ? Icons.search : CupertinoIcons.search;

  /// Icons: Icons.settings : CupertinoIcons.settings
  IconData get settings =>
      isMaterial(context) ? Icons.settings : CupertinoIcons.settings;

  /// Icons: Icons.settings : CupertinoIcons.settings_solid
  IconData get settingsSolid =>
      isMaterial(context) ? Icons.settings : CupertinoIcons.settings_solid;

  /// Icons: Icons.share : CupertinoIcons.share
  IconData get share =>
      isMaterial(context) ? Icons.share : CupertinoIcons.share;

  /// Icons: Icons.share : CupertinoIcons.share_solid
  IconData get shareSolid =>
      isMaterial(context) ? Icons.share : CupertinoIcons.share_solid;

  /// Icons: Icons.shuffle : CupertinoIcons.shuffle
  IconData get shuffle =>
      isMaterial(context) ? Icons.shuffle : CupertinoIcons.shuffle;

  /// Icons: Icons.star : CupertinoIcons.(custom)
  IconData get star => isMaterial(context)
      ? Icons.star
      : const IconData(
          0xf2fc,
          fontFamily: 'CupertinoIcons',
          fontPackage: 'cupertino_icons',
        );

  /// Icons: Icons.schedule : CupertinoIcons.time
  IconData get time =>
      isMaterial(context) ? Icons.schedule : CupertinoIcons.time;

  /// Icons: Icons.schedule : CupertinoIcons.time
  IconData get chat =>
      isMaterial(context) ? Icons.chat : CupertinoIcons.chat_bubble_fill;

  IconData get more =>
      isMaterial(context) ? Icons.more_vert : CupertinoIcons.ellipsis;

  IconData get back =>
      isMaterial(context) ? Icons.arrow_back : Icons.arrow_back_ios_rounded;
}
