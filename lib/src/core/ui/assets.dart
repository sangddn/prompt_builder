part of 'ui.dart';

enum UiAsset {
  // Logos
  darkIcon('$_logo/dark_icon', 'png'),
  lightIcon('$_logo/light_icon', 'png'),
  darkGradLogo('$_logo/dark_grad_logo', 'png'),
  lightGradLogo('$_logo/light_grad_logo', 'png'),
  primaryCreamLogo('$_logo/primary_cream', 'png'),
  primaryDarkLogo('$_logo/primary_dark', 'png'),
  wideDarkBg('$_logo/wide_dark_bg', 'png'),
  wideCreamBg('$_logo/wide_cream_bg', 'png'),
  darkTitledCreamBg('$_logo/dark_titled_cream_bg', 'png'),
  creamTitledDarkBg('$_logo/dark_titled_dark_bg', 'png'),
  wideDarkNoBg('$_logo/wide_dark_no_bg', 'png'),
  wideCreamNoBg('$_logo/wide_cream_no_bg', 'png'),
  primaryCreamTitled('$_logo/primary_cream_titled', 'png'),
  primaryDarkTitled('$_logo/primary_dark_titled', 'png'),
  lightLoadingIndicator('$_logo/light_loading_indicator', 'gif'),
  darkLoadingIndicator('$_logo/dark_loading_indicator', 'gif'),
  lightLoadingLogo('$_logo/light_loading_logo', 'gif'),
  darkLoadingLogo('$_logo/dark_loading_logo', 'gif'),
  darkIconNoBg('$_logo/dark_icon_no_bg', 'svg'),
  lightIconNoBg('$_logo/light_icon_no_bg', 'svg'),

  // Backgrounds
  bkgd1('$_bkgd/g1', 'png'),
  bkgd2('$_bkgd/g2', 'png'),
  bkgd3('$_bkgd/g3', 'png'),
  bkgd4('$_bkgd/g4', 'png'),
  bkgd5('$_bkgd/g5', 'png'),

  // Misc
  lineSpacing('$_imgMisc/line_spacing', 'svg'),
  letterSpacing('$_imgMisc/letter_spacing', 'svg'),
  wordSpacing('$_imgMisc/word_spacing', 'svg'),
  margin('$_imgMisc/margin', 'svg'),

  // Misc logos
  appleHealth('$_imgMisc/apple_health', 'png'),
  healthConnect('$_imgMisc/health_connect', 'png'),
  notion('$_imgMisc/notion', 'png'),
  googleCalendar('$_imgMisc/google_calendar', 'png'),
  appleCalendar('$_imgMisc/apple_calendar', 'png'),
  googlePhotos('$_imgMisc/google_photos', 'png'),
  applePhotos('$_imgMisc/apple_photos', 'png'),
  google('$_imgMisc/google_logo', 'svg'),
  twitterX('$_imgMisc/twitter_x', 'svg'),
  instagram('$_imgMisc/instagram', 'png'),

  // Animations
  sadDog('$_anim/sad_dog', 'json'),
  gotMail('$_anim/got_mail', 'json'),
  lockShield('$_anim/lock_shield', 'json'),
  lockSnapCircle('$_anim/lock_snap_circle', 'json'),

  // Haptics
  gravel('$_haptics/gravel', 'ahap'),
  heartbeats('$_haptics/heartbeats', 'ahap'),
  inflate('$_haptics/inflate', 'ahap'),
  rumble('$_haptics/rumble', 'ahap'),
  texture('$_haptics/texture', 'ahap'),

  // Graphics
  featureRequest('$_imgMisc/questions', 'png'),
  inviteFriends('$_imgMisc/invite_friends', 'png');

  const UiAsset(this.pathWoExt, this.ext);

  final String pathWoExt;
  final String ext;
}

const _assets = 'assets';
const _image = '$_assets/images';
// const _sound = '${_assets}/sounds';
const _haptics = '$_assets/haptics';
const _anim = '$_assets/animations';

const _bkgd = '$_image/backgrounds';
const _logo = '$_image/logos';
const _imgMisc = '$_image/misc';

// const _soundEffect = '${_sound}/sound_effects';

extension UiAssetX on UiAsset {
  String get path => '$pathWoExt.$ext';
  bool get isSvg => ext == 'svg';
  bool get isPng => ext == 'png';
  bool get isGif => ext == 'gif';
  bool get isJson => ext == 'json';
  bool get isAhap => ext == 'ahap';

  AssetImage toImage() => AssetImage(path);
}
