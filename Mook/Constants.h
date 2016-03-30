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
    kContentTypeIdea = 0,
    kContentTypeShow,
    kContentTypeRoutine,
    kContentTypeSleight,
    kContentTypeProp,
    kContentTypeLines,
    kContentTypeTag
} ContentType;

typedef enum {
    kEditingContentTypeIdea = 0,
    kEditingContentTypeRoutine,
    kEditingContentTypeSleight,
    kEditingContentTypeProp,
    kEditingContentTypeLines
} EditingContentType;


#define kDataListAll   [(AppDelegate *)[[UIApplication sharedApplication] delegate] allItems]
#define kDataListIdea   [(AppDelegate *)[[UIApplication sharedApplication] delegate] ideaObjModelList]
#define kDataListShow   [(AppDelegate *)[[UIApplication sharedApplication] delegate] showModelList]
#define kDataListRoutine   [(AppDelegate *)[[UIApplication sharedApplication] delegate] routineModelList]
#define kDataListSleight   [(AppDelegate *)[[UIApplication sharedApplication] delegate] sleightObjModelList]
#define kDataListProp   [(AppDelegate *)[[UIApplication sharedApplication] delegate] propObjModelList]
#define kDataListLines   [(AppDelegate *)[[UIApplication sharedApplication] delegate] linesObjModelList]

#define kDataListTagAll   [(AppDelegate *)[[UIApplication sharedApplication] delegate] allTags]

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
#define kCheckIfShouldPasswordKey        @"checkIfShouldPasswordKey"

#pragma mark -  NSCoding Key
//
//#define kShowNameKey        @"kShowNameKey"
//#define kShowDurationKey    @"kShowDurationKey"
//#define kShowOpenerKey      @"kShowOpenerKey"
//#define kShowMiddleKey      @"kShowMiddleKey"
//#define kShowEndingKey      @"kShowEndingKey"
//
//#define kIdeaInfoModelKey       @"kIdeaInfoModelKey"
//#define kIdeaPrepModelListKey @"kIdeaPrepModelListKey"
//#define kIdeaEffectModelKey  @"kIdeaEffectModelKey"
//#define kSleightInfoModelKey    @"kSleightInfoModelKey"
//#define kSleightEffectModelKey  @"kSleightEffectModelKey"
//#define kSleightPrepModelListKey @"kSleightPrepModelListKey"
//
//#define kLinesInfoModelKey      @"kLinesInfoModelKey"
//#define kLinesEffectModelKey    @"kLinesEffectModelKey"
//
//#define kPropInfoModelKey    @"kPropInfoModelKey"
//#define kPropEffectModelKey  @"kPropEffectModelKey"
//#define kPropPrepModelListKey @"kPropPrepModelListKey"
//
//#define kRoutineModelListKey    @"kRoutineModelListKey"
//#define kDateKey         @"kDateKey"
//#define kTagListKey         @"kTagListKey"
//
//#define kInfoModelKey           @"kInfoModelKey"
//#define kEffectModelKey         @"kEffectModelKey"
//#define kPropModelListKey       @"kPropModelListKey"
//#define kPrepModelListKey       @"kPrepModelListKey"
//#define kPerformModelListKey    @"kPerformModelListKey"
//#define kNotesModelListKey      @"kNotesModelListKey"

#define kNotesKey       @"kNotesKey"

#define kPerformKey    @"kPerformKey"
#define kPerformLinesKey    @"kPerformLinesKey"
#define kPerformNotesKey    @"kPerformNotesKey"
#define kPerformImageKey    @"kPerformImageKey"

#define kPrepKey    @"kPrepKey"
#define kPrepNotesKey    @"kPrepNotesKey"
#define kPrepImageKey    @"kPrepImageKey"
#define kPrepVideoKey    @"kPrepVideoKey"
#define kPerformVideoKey    @"kPerformVideoKey"

#define kEffectKey      @"kEffectKey"
#define kEffectVideoKey @"kEffectVideoKey"
#define kEffectImageKey @"kEffectImageKey"

#define kPropKey        @"kPropKey"
#define kPropQuantityKey    @"kPropQuantityKey"
#define kPropDetialKey  @"kPropDetialKey"

#define kInfoNameKey    @"kInfoNameKey"
#define kInfoTagsKey    @"kInfoTagsKey"

#pragma mark - segue ID
// segue

#define kSegueHomeToList    @"homeToListSegue"
#define kSeguekHomeToTagList @"kHomeToTagListSegue"
#define kSegueTagToListSegue    @"tagToListSegue"

#define kSegueListToContent @"listToContentSegue"
#define kSegueHomeToNewEntry @"homeToNewEntrySegue"
#define kSegueListToNewEntry   @"listToNewEntrySegue"

#define kEditingSegue   @"editingSegue"
#define kPropInputSegue @"propInputSegue"

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

#pragma mark - Font
// 字体相关
#define kFontSys10    [UIFont systemFontOfSize:10]
#define kFontSys12    [UIFont systemFontOfSize:12]
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

#define kListCellHeight     90
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
// 颜色相关
//#define kDisplayBgColor     [UIColor colorWithWhite:0.9 alpha:1.0]
//#define kDisplayBgColor         [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0]
//#define kDisplayBgColor     [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0] //默认uitableview grouped 背景颜色

#define kSwipeCellButtonColor   [UIColor colorWithRed:3/255.0 green:146/255.0 blue:207/255.0 alpha:1.0]

#define kBarTintColor     [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0]

#define kTintColor          [UIColor colorWithContrastingBlackOrWhiteColorOn:[UIColor flatMintColorDark] isFlat:YES]    // FlatColor
#define kMenuBackgroundColor    [UIColor flatMintColorDark]
//#define kTintColor     [UIColor colorWithRed:248/255.0 green:128/255.0 blue:4/255.0 alpha:1.0] //黄色
//#define kMenuBackgroundColor    [UIColor colorWithRed:26/255.0 green:29/255.0 blue:33/255.0 alpha:1.0]

//#define kTintColor  [UIColor colorWithRed:26/255.0 green:29/255.0 blue:33/255.0 alpha:1.0]


//#define kCellBgColor     [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0]
#define kCellBgColor     [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]

#define kSeperatorBgColor     [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1]
#define kDisplayBgColor     [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0]

#define kToolBarBgColor     [UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1.0]
//#define kBarColor     [UIColor colorWithRed:0/255.0 green:128/255.0 blue:255/255.0 alpha:1.0]
//#define kBarColor     [UIColor colorWithRed:0/255.0 green:102/255.0 blue:204/255.0 alpha:1.0]
//#define kBarColor     [UIColor colorWithRed:0/255.0 green:115/255.0 blue:230/255.0 alpha:1.0]
#define kBarColor     [UIColor colorWithRed:3/255.0 green:146/255.0 blue:207/255.0 alpha:1.0]   // # 0392CF

//#define kHeaderViewColor     [UIColor colorWithRed:79/255.0 green:91/255.0 blue:102/255.0 alpha:1.0]
//#define kHeaderViewColor     [UIColor colorWithRed:101/255.0 green:115/255.0 blue:126/255.0 alpha:1.0]
//#define kHeaderViewColor     [UIColor colorWithRed:45/255.0 green:45/255.0 blue:49/255.0 alpha:1.0]
#define kHeaderViewColor     [UIColor colorWithRed:35/255.0 green:141/255.0 blue:203/255.0 alpha:1.0]

#define kMenuButtomColor    [UIColor clearColor]
//#define kMenuBackgroundColor    [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]
//#define kMenuBackgroundColor    [UIColor colorWithRed:43/255.0 green:59/255.0 blue:78/255.0 alpha:1.0]


//#define kMenuBackgroundColor    kBarColor

#pragma mark - NSStrings
// NSString
#define kTypeRoutine    @"routine"
#define kTypeIdea    @"idea"
#define kTypeSleight    @"sleight"
#define kTypeProp    @"prop"
#define kTypeLines    @"lines"

#define kDefaultTitleAll   @"全部"
#define kDefaultTitleShow @"演出"
#define kDefaultTitleRoutine   @"流程"
#define kDefaultTitleIdea   @"灵感"
#define kDefaultTitleSleight   @"技巧"
#define kDefaultTitleProp   @"道具"
#define kDefaultTitleLines   @"梗"
#define kDefaultTitleTag   @"标签"

#define kNewRoutineInfoText    @"新建流程"
#define kNewIdeaInfoText    @"新建灵感"
#define kNewSleightInfoText    @"新建手法"
#define kNewPropInfoText    @"新建道具"
#define kNewLinesInfoText   @"新建台词"

#define kIconNameAll       @"iconNameAll"
#define kIconNameIdea       @"iconNameIdea"
#define kIconNameShow       @"iconNameShow"
#define kIconNameRoutine    @"iconNameRoutine"
#define kIconNameSleight    @"iconNameSleight"
#define kIconNameProp       @"iconNameProp"
#define kIconNameLines      @"iconNameLines"
#define kIconNameTag        @"iconNameTag"

#pragma mark - Notifications

#define kUpdateDataNotification @"updateDataNotification"
#define kUpdateEntryVCNotification  @"UpdateEntryVCNotification"
#define kUpdateShowsNotification @"UpdateShowsNotification"
#define kUpdateRoutinesNotification  @"UpdateRoutinesNotification"
#define kUpdateIdeasNotification @"UpdateIdeasNotification"
#define kUpdateSleightsNotification  @"UpdateSleightsNotification"
#define kUpdatePropsNotification @"UpdatePropsNotification"
#define kUpdateLinesNotification @"UpdateLinesNotification"
#define kUpdateTagsNotification @"UpdateTagsNotification"

#define kDismissNewEntryNavVCNotification   @"kDismissNewEntryNavVCNotification"
#define kDismissSettingNavVCNotification  @"kDismissSettingNavVCNotification"

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

#define kToolBarFavorImage  [UIImage imageNamed:@"toolBarFavor"]
#define kToolBarFavorImageHighlighted   [UIImage imageNamed:@"toolBarFavorHighlighted"]

#define kToolBarApproveImage  [UIImage imageNamed:@"toolBarApprove"]
#define kToolBarApproveImageHighlighted   [UIImage imageNamed:@"toolBarApproveHighlighted"]


#define kToolBarUpImage   [UIImage imageNamed:@"toolBarUp"]
#define kToolBarUpImageHighlighted    [UIImage imageNamed:@"toolBarUpHighlighted"]

#define kToolBarDownImage   [UIImage imageNamed:@"toolBarDown"]
#define kToolBarDownImageHighlighted    [UIImage imageNamed:@"toolBarDownHighlighted"]

#define kHeaderAddImage   [UIImage imageNamed:@"headerAdd"]
#define kHeaderAddImageHighlighted    [UIImage imageNamed:@"headerAddHighlighted"]

#define kHeaderReorderImage   [UIImage imageNamed:@"headerReorder"]
#define kHeaderReorderImageHighlighted    [UIImage imageNamed:@"headerReorderHighlighted"]

#endif /* Constants_h */
