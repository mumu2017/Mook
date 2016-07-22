//
//  Constants.h
//  Deck
//
//  Created by 陈林 on 15/11/5.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

typedef enum {
    kListTypeAll = 0,
    kListTypeIdea,
    kListTypeShow,
    kListTypeRoutine,
    kListTypeSleight,
    kListTypeProp,
    kListTypeLines,
} ListType;

typedef enum {
    kMediaUnitTypeNone = 0,
    kMediaUnitTypeImage,
    kMediaUnitTypeVideo,
    kMediaUnitTypeAudio,
} MediaUnitType;


typedef enum {
    kContentTypeIdea = 0,
    kContentTypeShow,
    kContentTypeRoutine,
    kContentTypeSleight,
    kContentTypeProp,
    kContentTypeLines,
    kContentTypeTag
} ContentType;


typedef enum {
    kWebSiteModeSite = 0,
    kWebSiteModeNotes
} WebSiteMode;


typedef enum {
    kEditingContentTypeIdea = 0,
    kEditingContentTypeRoutine,
    kEditingContentTypeSleight,
    kEditingContentTypeProp,
    kEditingContentTypeLines,
    kEditingContentTypeShow
} EditingContentType;

typedef enum {
    kEditingModeEffect = 0,
    kEditingModeProp,
    kEditingModePrep,
    kEditingModePerform,
    kEditingModeNotes,
} EditingMode;

typedef enum {
    
    flatBlueColorDark = 0,
    flatBlackColorDark,
    flatForestGreenColorDark,
    flatGreenColorDark,
    flatMagentaColorDark,
    flatMaroonColorDark,
    flatMintColorDark,
    flatNavyBlueColorDark,
    flatOrangeColorDark,
    flatPinkColorDark,
    flatPlumColorDark,
    flatPurpleColorDark,
    flatRedColorDark,
    flatSkyBlueColorDark,
    flatTealColorDark,
    flatWatermelonColorDark,
   
} kThemeColorSet;

#define kAppDelegate   (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define kAppThemeColor   [(AppDelegate *)[[UIApplication sharedApplication] delegate] themeColor]
#define kDataListAll   [(AppDelegate *)[[UIApplication sharedApplication] delegate] allItems]
#define kDataListIdea   [(AppDelegate *)[[UIApplication sharedApplication] delegate] ideaObjModelList]
#define kDataListShow   [(AppDelegate *)[[UIApplication sharedApplication] delegate] showModelList]
#define kDataListRoutine   [(AppDelegate *)[[UIApplication sharedApplication] delegate] routineModelList]
#define kDataListSleight   [(AppDelegate *)[[UIApplication sharedApplication] delegate] sleightObjModelList]
#define kDataListProp   [(AppDelegate *)[[UIApplication sharedApplication] delegate] propObjModelList]
#define kDataListLines   [(AppDelegate *)[[UIApplication sharedApplication] delegate] linesObjModelList]

#define kDataListTagAll   [(AppDelegate *)[[UIApplication sharedApplication] delegate] allTags]
#define kDataListTagShow   [(AppDelegate *)[[UIApplication sharedApplication] delegate] allTagsShow]
#define kDataListTagIdea   [(AppDelegate *)[[UIApplication sharedApplication] delegate] allTagsIdea]
#define kDataListTagRoutine   [(AppDelegate *)[[UIApplication sharedApplication] delegate] allTagsRoutine]
#define kDataListTagSleight   [(AppDelegate *)[[UIApplication sharedApplication] delegate] allTagsSleight]
#define kDataListTagProp   [(AppDelegate *)[[UIApplication sharedApplication] delegate] allTagsProp]
#define kDataListTagLines   [(AppDelegate *)[[UIApplication sharedApplication] delegate] allTagsLines]


#define kMenuVCID   @"MenuVC"
#define kRoutineListVCID    @"RoutineListVC"
#define kRoutineVCID        @"RoutineVC"
#define kNewRoutineVCID     @"NewRoutineVC"

#pragma mark - NSUserDefaults Key

#define kQuickStringKey     @"quickStringKey"
#define kUsePasswordKey     @"usePassword"
#define kSavePhotoKey       @"savePhoto"
#define kSaveVideoKey       @"saveVideo"
#define kPasswordKey        @"password"
#define kVoiceLanguageKey   @"voiceLanguageKey"
#define kNotFirstTimeLaunchKey        @"notFirstTimeLaunchKey"
#define kPasswordReminderKey     @"passwordReminderKey"
#define kTouchIDKey        @"touchIDKey"
#define kCheckIfShouldPasswordKey        @"checkIfShouldPasswordKey"
#define kThemeColorKey  @"themeColorKey"
#pragma mark -  NSCoding Key

#define kNotesKey       @"kNotesKey"
#define kNotesAudioKey  @"kNotesAudioKey"

#define kPerformKey    @"kPerformKey"
#define kPerformLinesKey    @"kPerformLinesKey"
#define kPerformNotesKey    @"kPerformNotesKey"
#define kPerformImageKey    @"kPerformImageKey"

#define kPrepKey    @"kPrepKey"
#define kPrepNotesKey    @"kPrepNotesKey"
#define kPrepImageKey    @"kPrepImageKey"
#define kPrepVideoKey    @"kPrepVideoKey"
#define kPrepAudioKey   @"kPrepAudioKey"

#define kPerformVideoKey    @"kPerformVideoKey"
#define kPerformAudioKey    @"kPerformAudioKey"

#define kEffectKey      @"kEffectKey"
#define kEffectVideoKey @"kEffectVideoKey"
#define kEffectImageKey @"kEffectImageKey"
#define kEffectAudioKey @"kEffectAudioKey"

#define kPropKey        @"kPropKey"
#define kPropQuantityKey    @"kPropQuantityKey"
#define kPropDetialKey  @"kPropDetialKey"

#define kInfoNameKey    @"kInfoNameKey"
#define kInfoTagsKey    @"kInfoTagsKey"

#pragma mark - segue ID
// segue

#define kSegueHomeToNewShowSegue    @"homeToNewShowSegue"
#define kSegueHomeToContentSegue    @"homeToContentSegue"
#define kSegueHomeToShowSegue   @"homeToShowSegue"
#define kSegueHomeToNewEntrySegue   @"homeToNewEntrySegue"

#define kSegueHomeToList    @"homeToListSegue"
#define kSeguekHomeToTagList @"kHomeToTagListSegue"
#define kSegueTagToListSegue    @"tagToListSegue"

#define kSegueMediaToContent    @"mediaToContentSegue"
#define kSegueMediaToShow    @"mediaToShowSegue"

#define kSegueListToContent @"listToContentSegue"
#define kSegueListToShow   @"listToShowSegue"
#define kSegueShowToRoutine    @"showToRoutineSegue"
#define kSegueHomeToNewEntry @"homeToNewEntrySegue"
#define kSegueListToNewEntry   @"listToNewEntrySegue"
#define kSegueListToNewShow     @"listToNewShowSegue"
#define kSegueHomeToNewShow    @"homeToNewShowSegue"
#define KSegueListToNewShow     @"listToNewShowSegue"
#define kSegueNewShowToEditingSegue @"newShowToEditingSegue"
#define kSegueNewShowToRoutineChoose   @"newShowToRoutineChooseSegue"

#define kQuickStringSegue   @"quickStringSegue"
#define kEditingSegue   @"editingSegue"
#define kPropInputSegue @"propInputSegue"
#define kBackUpInfoSegue    @"backUpInfoSegue"

#define kMookToNewShowSegue      @"mookToNewShowSegue"
#define kMookToNewRoutineSegue      @"mookToNewRoutineSegue"
#define kMookToShowSegue      @"mookToShowSegue"
#define kMookToRoutineSegue      @"mookToRoutineSegue"
#define kMookToIdeaSegue       @"mookToIdeaSegue"
#define kMookToSleightSegue       @"mookToSleightSegue"
#define kMookToPropSegue       @"mookToPropSegue"
#define kMookToLinesSegue       @"mookToLinesSegue"
#define kMookToPasswordSegue    @"mookToPasswordSegue"


#define kRoutineListToLibrarySegue  @"routineListToLibrarySegue"
#define kRoutineListToTagListSegue  @"routineListToTagListSegue"
#define kShowListToShowSegue        @"showListToShowSegue"
#define kShowListAddNewShowSegue  @"showListVCAddNewShowSegue"
#define kNewShowChooseRoutineSegue  @"newShowChooseRoutineSegue"
#define kShowToRoutineSegue         @"showToRoutineSegue"
#define kNewShowChooseTagSegue      @"newShowChooseTagSegue"

#define kRoutineListToShowListSegue @"routineListToShowListSegue"
#define kRoutineListToRoutineSegue  @"routineListToRoutineSegue"
#define kRoutineListToNewRoutineSegue   @"routineListToNewRoutineSegue"
#define kRoutineListAddNewRoutineSegue   @"routineListAddNewRoutineSegue"
#define kRoutineEditSegue           @"routineEditSegue"
#define kPropEditVCToNewPropSegue   @"propEditVCToNewPropSegue"

#define kNewEntryChooseTagSegue      @"newEntryChooseTagSegue"
#define kNewRoutineChoosePropSegue   @"newRoutineChoosePropSegue"
#define kNewRoutineChooseLinesSegue   @"newRoutineChooseLinesSegue"
#define kNewRoutineChooseSleightSegue   @"newRoutineChooseSleightSegue"

#define kIdeaListToIdeaSegue        @"ideaListToIdeaSegue"
#define kIdeaListToNewIdeaSegue     @"ideaListToNewIdeaSegue"
#define kIdeaEditSegue              @"ideaEditSegue"
#define kEffectEditSegue            @"effectEditSegue"
#define kPropEditSegue             @"propEditSegue"
#define kPrepEditSegue              @"prepVCEditSegue"
#define kPerfromEditSegue           @"perfromEditSegue"
#define kPerformDetailInputSegue    @"performDetailInputSegue"
#define kNotesEditSegue             @"notesEditSegue"

#define kSleightListToSleightSegue        @"sleightListToSleightSegue"
#define kSleightListToNewSleightSegue     @"sleightListToNewSleightSegue"
#define kSleightEditSegue              @"sleightEditSegue"

#define kPropListToPropSegue        @"propListToPropSegue"
#define kPropListToNewPropSegue     @"propListToNewPropSegue"
#define kPropEditSegue              @"propEditSegue"

#define kLinesListToLinesSegue   @"linesListToLinesSegue"
#define kLinesListToNewLinesSegue    @"linesListToNewLinesSegue"
#define kLinesEditSegue             @"linesEditSegue"

#define kTagListToShowListSegue     @"tagListToShowListSegue"
#define kTagListToRoutineListSegue  @"tagListToRoutineListSegue"
#define kTagListToIdeaListSegue  @"tagListToIdeaListSegue"
#define kTagListToSleightListSegue  @"tagListToSleightListSegue"
#define kTagListToPropListSegue  @"tagListToPropListSegue"
#define kTagListToLinesListSegue  @"tagListToLinesListSegue"

#define kSettingToRoutinePDFSegue    @"settingToRoutinePDFSegue"
#define kSettingToPasswordSegue     @"settingToPasswordSegue"
#define kQuickStringEditSegue       @"quickStringEditSegue"
#define kSizeListSegue   @"sizeListSegue"
#pragma mark - Font
// 字体相关
#define kFontSys10    [UIFont systemFontOfSize:10]
#define kFontSys12    [UIFont systemFontOfSize:12]
#define kFontSys13    [UIFont systemFontOfSize:13]
#define kFontSys14    [UIFont systemFontOfSize:14]
#define kFontSys16    [UIFont systemFontOfSize:16]
#define kFontSys17    [UIFont systemFontOfSize:17]
#define kFontSys18    [UIFont systemFontOfSize:18]

#define kItalicFontSys12 [UIFont italicSystemFontOfSize:12]
#define kItalicFontSys14 [UIFont italicSystemFontOfSize:14]
#define kItalicFontSys16 [UIFont italicSystemFontOfSize:16]
#define kItalicFontSys18 [UIFont italicSystemFontOfSize:18]

#define kBoldFontSys14  [UIFont boldSystemFontOfSize:14]
#define kBoldFontSys16  [UIFont boldSystemFontOfSize:16]
#define kBoldFontSys17  [UIFont boldSystemFontOfSize:17]
#define kBoldFontSys18  [UIFont boldSystemFontOfSize:18]
#define kBoldFontSys24  [UIFont boldSystemFontOfSize:24]

#define kFont14Dict     @{NSFontAttributeName : kFontSys14}
#define kFont16Dict     @{NSFontAttributeName : kFontSys16}
#define kSizeForText    CGSizeMake(kContentW, MAXFLOAT)

#pragma mark - Size
// 尺寸相关
#define kScreenBounds   [UIScreen mainScreen].bounds
#define kScreenW        [UIScreen mainScreen].bounds.size.width
#define kScreenH        [UIScreen mainScreen].bounds.size.height

#define kAddButtonHeight    60
#define kListCellHeight     120
#define kStatusBarHeight    20
#define kNavigationBarHeight    44

#define kPadding    10.0f
#define kHeaderLabelX   15.0f
#define kContentW   (kScreenW - kPadding * 2)

#define kOriginalTextViewHeight     30
#define kButtonHeight   30
#define kLabelHeight    36

#define kImageDisplayW      kContentW
#define kImageDisplayH     (kContentW * 0.75)
#define kImageEditW     30
#define kImageEditH     30

#define kVideoDisplayW      kContentW
#define kVideoDisplayH      (kContentW * 0.75)

#pragma mark - Tags
// 控件Tag
#define kInfoNameLabel  11
#define kInfoTagLabel   12
#define kPropLabel      13
#define kPrepNoticeLabel    14
#define kPerformLinewLabel  15
#define kPerformNoticeLabel 16

#define kNameTextView     19
#define kPropTextView     20
#define kEffectTextView     21
#define kPrepTextView       22
#define kNotesTextView     23
#define kPerformTextView    24
#define kPerformLinesTextView     25
#define kPerformSecretTextView     26

#pragma mark - Table View
// 表格相关
// section
#define kInfoSection    0
#define kEffectSection  1
#define kPropSection    2
#define kPrepSection    3
#define kPerformSection 4
#define kNotesSection   5

// reuseIdentifier
#define kMenuCellID         @"menuCell"

#define kOneLabelCellID     @"oneLabelCell"
#define kTwoLabelCellID       @"twoLabelCell"
#define kMediaCellID        @"meidaCell"
#define kPerformInfoCellID  @"performInfoCell"

#define kEditCellID      @"editCell"
#define kShowCellID         @"showCell"
#define kRoutineCellID      @"routineCell"
#define kShowListImageCellID    @"showListImageCell"
#define kShowListTextCellID     @"showListTextCell"
#define kListTextCellID     @"listTextCell"
#define kListImageCellID     @"listImageCell"
#define kListCellID     @"listCell"

#define kOneLabelImageCellID     @"oneLabelImageCell"
#define kQuickStringCellID     @"quickStringCell"

#define kIdeaObjCellID      @"ideaObjCellID"
#define kSleightObjCellID   @"ideaObjCellID"
#define kPropObjCellID      @"propObjCellID"
#define kLinesObjCellID     @"linesObjCellID"

#define kIdeaCellID     @"ideaCell"

#define kInfoCellID     @"infoCell"
#define kEffectCellID   @"effectCell"
#define kEffectMediaCellID    @"effectMediaCell"
#define kPropCellID     @"propCell"

#define kAddPropCellID    @"addPropCell"

#define kPrepCellID     @"prepCell"
#define kAddPrepCellID    @"addPrepCell"

#define kPerformCellID  @"performCell"
#define kAddPerformCellID @"addPerformCell"
#define kNotesCellID    @"notesCell"
#define kAddNotesCellID @"addNotesCell"

#define kDeleteRoutineCellID  @"deleteRoutineCell"

#define kShowInfoCell    @"showInfoCell"
#define kRoutineImageCell    @"routineImageCell"
#define kRoutineTextCell    @"routineTextCell"

#define kTextCell   @"kTextCell"
#define kTextAudioCell  @"kTextAudioCell"
#define kTextImageCell  @"kTextImageCell"
#define kTextAudioImageCell @"kTextAudioImageCell"

#define kOneLabelDisplayCell    @"oneLabelDisplayCell"
#define kOneLabelMediaDisplayCell   @"oneLabelMediaDisplayCell"
#define kOneLabelImageDisplayCell @"oneLabelImageDisplayCell"
#define kInfoDisplayCellID     @"infoDisplayCell"
#define kEffectDisplayCellID   @"effectDisplayCell"
#define kPropDisplayCellID     @"propDisplayCell"
#define kPrepDisplayCellID     @"prepDisplayCell"
#define kPerformDisplayCellID  @"performDisplayCell"
#define kNotesDisplayCellID    @"notesDisplayCellID"

#define KTextInputCellID    @"textInputCellID"
#define kNewEntryImageCellID    @"newEntryImageCellID"
#define kNewEntryTextCellID     @"newEntryTextCellID"

#define kTagCell             @"tagCell"

#pragma mark - Colors

#define kSwipeCellButtonColor   [UIColor colorWithRed:3/255.0 green:146/255.0 blue:207/255.0 alpha:1.0]

#define kBarTintColor     [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0]

#define kTintColor          [UIColor colorWithContrastingBlackOrWhiteColorOn:kMenuBackgroundColor isFlat:YES]    // FlatColor
#define kMenuBackgroundColor    kAppThemeColor
// contentVC的背景色
#define kCellBgColor     [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1]


#define kSeperatorBgColor     [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1]
#define kDisplayBgColor     [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0]

#define kToolBarBgColor     [UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1.0]

#define kBarColor     [UIColor colorWithRed:3/255.0 green:146/255.0 blue:207/255.0 alpha:1.0]   // # 0392CF

#define kHeaderViewColor     [UIColor colorWithRed:35/255.0 green:141/255.0 blue:203/255.0 alpha:1.0]

#define kMenuButtomColor    [UIColor clearColor]

#pragma mark - NSStrings

#define kZipPassword    @"mookpassword"

#define kTypeShow    @"show"
#define kTypeRoutine    @"routine"
#define kTypeIdea    @"idea"
#define kTypeSleight    @"sleight"
#define kTypeProp    @"prop"
#define kTypeLines    @"lines"

#define kTypeWebSite    @"webSite"
#define kTypeWebNote    @"webNote"

#define kDefaultTitleAll   NSLocalizedString(@"全部", nil)
#define kDefaultTitleShow  NSLocalizedString(@"演出", nil)
#define kDefaultTitleRoutine   NSLocalizedString(@"流程", nil)
#define kDefaultTitleIdea   NSLocalizedString(@"想法", nil)
#define kDefaultTitleSleight   NSLocalizedString(@"技巧", nil)
#define kDefaultTitleProp   NSLocalizedString(@"道具", nil)
#define kDefaultTitleLines   NSLocalizedString(@"台词", nil)
#define kDefaultTitleTag   NSLocalizedString(@"标签", nil)

#define kNewShowInfoText    NSLocalizedString(@"新建演出", nil)
#define kNewRoutineInfoText    NSLocalizedString(@"新建流程", nil)
#define kNewIdeaInfoText    NSLocalizedString(@"新建想法", nil)
#define kNewSleightInfoText    NSLocalizedString(@"新建技巧", nil)
#define kNewPropInfoText    NSLocalizedString(@"新建道具", nil)
#define kNewLinesInfoText   NSLocalizedString(@"新建台词", nil)

//#define kIconNameAll       @"iconNameAll"
#define kIconNameIdea       NSLocalizedString(@"想法", nil)
#define kIconNameShow       NSLocalizedString(@"演出", nil)
#define kIconNameRoutine    NSLocalizedString(@"流程", nil)
#define kIconNameSleight    NSLocalizedString(@"技巧", nil)
#define kIconNameProp       NSLocalizedString(@"道具", nil)
#define kIconNameLines      NSLocalizedString(@"台词", nil)
//#define kIconNameTag        @"iconNameTag"

#define kVoiceChinese       @"chinese"
#define kVoiceGuangdong       @"guangdong"
#define kVoiceEnglish       @"english"

#pragma mark - Notifications

#define kDidMakeChangeNotification  @"didMakeChangeNotification"
#define kIFlyAppID  @"56c1951a"

#define kUpdateDataNotification @"updateDataNotification"

#define kUpdateMookNotification @"updateMookNotification"
#define kDeleteEntryNotification    @"deleteCurrentEntryNotification"
#define kCancelEntryNotification    @"cancelCurrentEntryNotification"

#define kUpdateEntryVCNotification  @"UpdateEntryVCNotification"
#define kUpdateShowsNotification @"UpdateShowsNotification"
#define kUpdateRoutinesNotification  @"UpdateRoutinesNotification"
#define kUpdateIdeasNotification @"UpdateIdeasNotification"
#define kUpdateSleightsNotification  @"UpdateSleightsNotification"
#define kUpdatePropsNotification @"UpdatePropsNotification"
#define kUpdateLinesNotification @"UpdateLinesNotification"
#define kUpdateTagsNotification @"UpdateTagsNotification"

#define kDismissNewShowNavVCNotification   @"kDismissNewShowNavVCNotification"
#define kDismissNewEntryNavVCNotification   @"kDismissNewEntryNavVCNotification"
#define kDismissSettingNavVCNotification  @"kDismissSettingNavVCNotification"

#pragma mark 搜索域名

#define kSearchUrlString  @"http://www.bing.com/"

#pragma mark - BOOL
#define kLinesInstructionsMode  0
#define kLinesGagsMode          1

#pragma mark - image
#define kOriginalTimaStamp     [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000]
#define kTimestamp             [kOriginalTimaStamp stringByReplacingOccurrencesOfString:@"." withString:@""]
#pragma mark - UIImage

#define kTagAddImage     [UIImage imageNamed:@"tagAdd"]
#define kTagChooseImage     [UIImage imageNamed:@"tagChoose"]

#define kToolBarAddImage    [UIImage imageNamed:@"toolBarAdd"]
#define kToolBarAddImageHighlighted [UIImage imageNamed:@"toolBarAddHighlighted"]

#define kToolBarMinusImage  [UIImage imageNamed:@"toolBarMinus"]
#define kToolBarMinusImageHighlighted   [UIImage imageNamed:@"toolBarMinusHighlighted"]

#define kToolBarPropImage  [UIImage imageNamed:@"toolBarProp"]
#define kToolBarPropImageHighlighted   [UIImage imageNamed:@"toolBarPropHighlighted"]

#define kToolBarWriteImage  [UIImage imageNamed:@"toolBarWrite"]
#define kToolBarApproveImageHighlighted   [UIImage imageNamed:@"toolBarWriteHighlighted"]

#define kToolBarVoiceImage  [UIImage imageNamed:@"toolBarVoice"]

#define kToolBarUpImage   [UIImage imageNamed:@"toolBarUp"]
#define kToolBarUpImageHighlighted    [UIImage imageNamed:@"toolBarUpHighlighted"]

#define kToolBarDownImage   [UIImage imageNamed:@"toolBarDown"]
#define kToolBarDownImageHighlighted    [UIImage imageNamed:@"toolBarDownHighlighted"]

#define kHeaderAddImage   [UIImage imageNamed:@"headerAdd"]
#define kHeaderAddImageHighlighted    [UIImage imageNamed:@"headerAddHighlighted"]

#define kHeaderReorderImage   [UIImage imageNamed:@"headerReorder"]
#define kHeaderReorderImageHighlighted    [UIImage imageNamed:@"headerReorderHighlighted"]

#endif /* Constants_h */
