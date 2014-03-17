//
// Created by AndrewShmig on 4/19/13.
//
// Copyright (c) 2013 Andrew Shmig
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
// FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//


static NSString *const kVkontakteAPIURL = @"https://api.vk.com/method/";
static NSString *const kVkontakteAuthorizationURL = @"https://oauth.vk.com/authorize";
static NSString *const kVkontakteBlankURL = @"https://oauth.vk.com/blank.html";

// -----------------------------------------------------------------------------
#pragma mark - Users
// -----------------------------------------------------------------------------
static NSString *const kVKUsersGet = @"users.get";
static NSString *const kVKUsersSearch = @"users.search";
static NSString *const kVKUsersIsAppUser = @"users.isAppUser";
static NSString *const kVKUsersGetSubscriptions = @"users.getSubscriptions";
static NSString *const kVKUsersGetFollowers = @"users.getFollowers";

// -----------------------------------------------------------------------------
#pragma mark - Groups
// -----------------------------------------------------------------------------
static NSString *const kVKGroupsIsMember = @"groups.isMember";
static NSString *const kVKGroupsGetById = @"group.getById";
static NSString *const kVKGroupsGet = @"groups.get";
static NSString *const kVKGroupsGetMembers = @"groups.getMembers";
static NSString *const kVKGroupsJoin = @"groups.join";
static NSString *const kVKGroupsLeave = @"groups.leave";
static NSString *const kVKGroupsSearch = @"groups.search";
static NSString *const kVKGroupsGetInvites = @"groups.getInvites";
static NSString *const kVKGroupsBanUser = @"groups.banUser";
static NSString *const kVKGroupsUnbanUser = @"groups.unbanUser";
static NSString *const kVKGroupsGetBanned = @"groups.getBanned";

// -----------------------------------------------------------------------------
#pragma mark - Friends
// -----------------------------------------------------------------------------
static NSString *const kVKFriendsGet = @"friends.get";
static NSString *const kVKFriendsGetOnline = @"friends.getOnline";
static NSString *const kVKFriendsGetMutual = @"friends.getMutual";
static NSString *const kVKFriendsGetRecent = @"friends.getRecent";
static NSString *const kVKFriendsGetRequests = @"friends.getRequests";
static NSString *const kVKFriendsAdd = @"friends.add";
static NSString *const kVKFriendsEdit = @"friends.edit";
static NSString *const kVKFriendsDelete = @"friends.delete";
static NSString *const kVKFriendsGetLists = @"friends.getLists";
static NSString *const kVKFriendsAddList = @"friends.addList";
static NSString *const kVKFriendsEditList = @"friends.editList";
static NSString *const kVKFriendsDeleteList = @"friends.deleteList";
static NSString *const kVKFriendsGetAppUsers = @"friends.getAppUsers";
static NSString *const kVKFriendsGetByPhones = @"friends.getByPhones";
static NSString *const kVKFriendsDeleteAllRequests = @"friends.deleteAllRequests";
static NSString *const kVKFriendsGetSuggestions = @"friends.getSuggestions";
static NSString *const kVKFriendsAreFriends = @"friends.areFriends";

// -----------------------------------------------------------------------------
#pragma mark - Wall
// -----------------------------------------------------------------------------
static NSString *const kVKWallGet = @"wall.get";
static NSString *const kVKWallGetById = @"wall.getById";
static NSString *const kVKWallSavePost = @"wall.savePost";
static NSString *const kVKWallPost = @"wall.post";
static NSString *const kVKWallRepost = @"wall.repost";
static NSString *const kVKWallGetReposts = @"wall.getReposts";
static NSString *const kVKWallEdit = @"wall.edit";
static NSString *const kVKWallDelete = @"wall.delete";
static NSString *const kVKWallRestore = @"wall.restore";
static NSString *const kVKWallGetComments = @"wall.getComments";
static NSString *const kVKWallAddComment = @"wall.addComment";
static NSString *const kVKWallDeleteComment = @"wall.deleteComment";
static NSString *const kVKWallRestoreComment = @"wall.restoreComment";

// -----------------------------------------------------------------------------
#pragma mark - Photos
// -----------------------------------------------------------------------------
static NSString *const kVKPhotosCreateAlbum = @"photos.createAlbum";
static NSString *const kVKPhotosEditAlbum = @"photos.editAlbum";
static NSString *const kVKPhotosGetAlbums = @"photos.getAlbums";
static NSString *const kVKPhotosGet = @"photos.get";
static NSString *const kVKPhotosGetAlbumsCount = @"photos.getAlbumsCount";
static NSString *const kVKPhotosGetProfile = @"photos.getProfile";
static NSString *const kVKPhotosGetById = @"photos.getById";
static NSString *const kVKPhotosGetUploadServer = @"photos.getUploadServer";
static NSString *const kVKPhotosGetProfileUploadServer = @"photos.getProfileUploadServer";
static NSString *const kVKPhotosSaveProfilePhoto = @"photos.saveProfilePhoto";
static NSString *const kVKPhotosSaveWallPhoto = @"photos.saveWallPhoto";
static NSString *const kVKPhotosGetWallUploadServer = @"photos.getWallUploadServer";
static NSString *const kVKPhotosGetMessagesUploadServer = @"photos.getMessagesUploadServer";
static NSString *const kVKPhotosGetChatUploadServer = @"photos.getChatUploadServer";
static NSString *const kVKPhotosSaveMessagesPhoto = @"photos.saveMessagesPhoto";
static NSString *const kVKPhotosSearch = @"photos.search";
static NSString *const kVKPhotosSave = @"photos.save";
static NSString *const kVKPhotosEdit = @"photos.edit";
static NSString *const kVKPhotosMove = @"photos.move";
static NSString *const kVKPhotosMakeCover = @"photos.makeCover";
static NSString *const kVKPhotosReorderAlbums = @"photos.reorderAlbums";
static NSString *const kVKPhotosReorderPhotos = @"photos.reorderPhotos";
static NSString *const kVKPhotosGetAll = @"photos.getAll";
static NSString *const kVKPhotosGetUserPhotos = @"photos.getUserPhotos";
static NSString *const kVKPhotosDeleteAlbum = @"photos.deleteAlbum";
static NSString *const kVKPhotosDelete = @"photos.delete";
static NSString *const kVKPhotosConfirmTag = @"photos.confirmTag";
static NSString *const kVKPhotosGetComments = @"photos.getComments";
static NSString *const kVKPhotosGetAllComments = @"photos.getAllComments";
static NSString *const kVKPhotosCreateComment = @"photos.createComment";
static NSString *const kVKPhotosDeleteComment = @"photos.deleteComment";
static NSString *const kVKPhotosRestoreComment = @"photos.restoreComment";
static NSString *const kVKPhotosEditComment = @"photos.editComment";
static NSString *const kVKPhotosGetTags = @"photos.getTags";
static NSString *const kVKPhotosPutTag = @"photos.putTag";
static NSString *const kVKPhotosRemoveTag = @"photos.removeTag";
static NSString *const kVKPhotosGetNewTags = @"photos.getNewTags";

// -----------------------------------------------------------------------------
#pragma mark - Video
// -----------------------------------------------------------------------------
static NSString *const kVKVideoGet = @"video.get";
static NSString *const kVKVideoEdit = @"video.edit";
static NSString *const kVKVideoAdd = @"video.add";
static NSString *const kVKVideoSave = @"video.save";
static NSString *const kVKVideoDelete = @"video.delete";
static NSString *const kVKVideoRestore = @"video.restore";
static NSString *const kVKVideoSearch = @"video.search";
static NSString *const kVKVideoGetUserVideos = @"video.getUserVideos";
static NSString *const kVKVideoGetAlbums = @"video.getAlbums";
static NSString *const kVKVideoAddAlbum = @"video.addAlbum";
static NSString *const kVKVideoEditAlbum = @"video.editAlbum";
static NSString *const kVKVideoDeleteAlbum = @"video.deleteAlbum";
static NSString *const kVKVideoMoveToAlbum = @"video.moveToAlbum";
static NSString *const kVKVideoGetComments = @"video.getComments";
static NSString *const kVKVideoCreateComment = @"video.createComment";
static NSString *const kVKVideoDeleteComment = @"video.deleteComment";
static NSString *const kVKVideoEditComment = @"video.editComment";
static NSString *const kVKVideoRestoreComment = @"video.restoreComment";
static NSString *const kVKVideoGetTags = @"video.getTags";
static NSString *const kVKVideoPutTag = @"video.putTag";
static NSString *const kVKVideoRemoveTag = @"video.removeTag";
static NSString *const kVKVideoGetNewTags = @"video.getNewTags";
static NSString *const kVKVideoReport = @"video.report";

// -----------------------------------------------------------------------------
#pragma mark - Audio
// -----------------------------------------------------------------------------
static NSString *const kVKAudioGet = @"audio.get";
static NSString *const kVKAudioGetById = @"audio.getById";
static NSString *const kVKAudioGetLyrics = @"audio.getLyrics";
static NSString *const kVKAudioSearch = @"audio.search";
static NSString *const kVKAudioGetUploadServer = @"audio.getUploadServer";
static NSString *const kVKAudioSave = @"audio.save";
static NSString *const kVKAudioAdd = @"audio.add";
static NSString *const kVKAudioDelete = @"audio.delete";
static NSString *const kVKAudioEdit = @"audio.edit";
static NSString *const kVKAudioReorder = @"audio.reorder";
static NSString *const kVKAudioRestore = @"audio.restore";
static NSString *const kVKAudioGetAlbums = @"audio.getAlbums";
static NSString *const kVKAudioAddAlbum = @"audio.addAlbum";
static NSString *const kVKAudioEditAlbum = @"audio.editAlbum";
static NSString *const kVKAudioDeleteAlbum = @"audio.deleteAlbum";
static NSString *const kVKAudioMoveToAlbum = @"audio.moveToAlbum";
static NSString *const kVKAudioGetBroadcast = @"audio.getBroadcast";
static NSString *const kVKAudioSetBroadcast = @"audio.setBroadcast";
static NSString *const kVKAudioGetRecommendations = @"audio.getRecommendations";
static NSString *const kVKAudioGetPopular = @"audio.getPopular";
static NSString *const kVKAudioGetCount = @"audio.getCount";

// -----------------------------------------------------------------------------
#pragma mark - Messages
// -----------------------------------------------------------------------------
static NSString *const kVKMessagesGet = @"messages.get";
static NSString *const kVKMessagesGetDialogs = @"messages.getDialogs";
static NSString *const kVKMessagesGetById = @"messages.getById";
static NSString *const kVKMessagesSearch = @"messages.search";
static NSString *const kVKMessagesGetHistory = @"messages.getHistory";
static NSString *const kVKMessagesSend = @"messages.send";
static NSString *const kVKMessagesDelete = @"messages.delete";
static NSString *const kVKMessagesDeleteDialog = @"messages.deleteDialog";
static NSString *const kVKMessagesRestore = @"messages.restore";
static NSString *const kVKMessagesMarkAsNew = @"messages.markAsNew";
static NSString *const kVKMessagesMarkAsRead = @"messages.markAsRead";
static NSString *const kVKMessagesMarkAsImportant = @"messages.markAsImportant";
static NSString *const kVKMessagesGetLongPollServer = @"messages.getLongPollServer";
static NSString *const kVKMessagesGetLongPollHistory = @"messages.getLongPollHistory";
static NSString *const kVKMessagesGetChat = @"messages.getChat";
static NSString *const kVKMessagesCreateChat = @"messages.createChat";
static NSString *const kVKMessagesEditChat = @"messages.editChat";
static NSString *const kVKMessagesGetChatUsers = @"messages.getChatUsers";
static NSString *const kVKMessagesSetActivity = @"messages.setActivity";
static NSString *const kVKMessagesSearchDialogs = @"messages.searchDialogs";
static NSString *const kVKMessagesAddChatUser = @"messages.addCharUser";
static NSString *const kVKMessagesRemoveChatUser = @"messages.removeChatUser";
static NSString *const kVKMessagesSetChatPhoto = @"messages.setChatPhoto";
static NSString *const kVKMessagesGetLastActivity = @"messages.getLastActivity";
static NSString *const kVKMessagesDeleteChatPhoto = @"messages.deleteChatPhoto";

// -----------------------------------------------------------------------------
#pragma mark - Newsfeed
// -----------------------------------------------------------------------------
static NSString *const kVKNewsfeedGet = @"newsfeed.get";
static NSString *const kVKNewsfeedGetRecommended = @"newsfeed.getRecommended";
static NSString *const kVKNewsfeedGetComments = @"newsfeed.getComments";
static NSString *const kVKNewsfeedGetMentions = @"newsfeed.getMentions";
static NSString *const kVKNewsfeedGetBanned = @"newsfeed.getBanned";
static NSString *const kVKNewsfeedAddBan = @"newsfeed.addBan";
static NSString *const kVKNewsfeedDeleteBan = @"newsfeed.deleteBan";
static NSString *const kVKNewsfeedSearch = @"newsfeed.search";
static NSString *const kVKNewsfeedGetLists = @"newsfeed.getLists";
static NSString *const kVKNewsfeedUnsubscribe = @"newsfeed.unsubscribe";

// -----------------------------------------------------------------------------
#pragma mark - Likes
// -----------------------------------------------------------------------------
static NSString *const kVKLikesGetList = @"likes.getList";
static NSString *const kVKLikesAdd = @"likes.add";
static NSString *const kVKLikesDelete = @"likes.delete";
static NSString *const kVKLikesIsLiked = @"likes.isLiked";

// -----------------------------------------------------------------------------
#pragma mark - Account
// -----------------------------------------------------------------------------
static NSString *const kVKAccountGetCounters = @"account.getCounters";
static NSString *const kVKAccountSetNameInMenu = @"account.setNameInMenu";
static NSString *const kVKAccountSetOnline = @"account.setOnline";
static NSString *const kVKAccountImportContacts = @"account.importContacts";
static NSString *const kVKAccountRegisterDevice = @"account.registerDevice";
static NSString *const kVKAccountUnregisterDevice = @"account.unregisterDevice";
static NSString *const kVKAccountSetSilenceMode = @"account.setSilenceMode";
static NSString *const kVKAccountGetPushSettings = @"account.getPushSettings";
static NSString *const kVKAccountGetAppPermissions = @"account.getAppPermissions";
static NSString *const kVKAccountGetActiveOffers = @"account.getActiveOffers";
static NSString *const kVKAccountBanUser = @"account.banUser";
static NSString *const kVKAccountUnbanUser = @"account.unbanUser";
static NSString *const kVKAccountGetBanned = @"account.getBanned";
static NSString *const kVKAccountTestValidation = @"account.testValidation";

// -----------------------------------------------------------------------------
#pragma mark - Status
// -----------------------------------------------------------------------------
static NSString *const kVKStatusGet = @"status.get";
static NSString *const kVKStatusSet = @"status.set";

// -----------------------------------------------------------------------------
#pragma mark - Pages
// -----------------------------------------------------------------------------
static NSString *const kVKPagesGet = @"pages.get";
static NSString *const kVKPagesSave = @"pages.save";
static NSString *const kVKPagesSaveAccess = @"pages.saveAccess";
static NSString *const kVKPagesGetHistory = @"pages.getHistory";
static NSString *const kVKPagesGetTitles = @"pages.getTitles";
static NSString *const kVKPagesGetVersion = @"pages.getVersion";
static NSString *const kVKPagesParseWiki = @"pages.parseWiki";

// -----------------------------------------------------------------------------
#pragma mark - Board
// -----------------------------------------------------------------------------
static NSString *const kVKBoardGetTopics = @"board.getTopics";
static NSString *const kVKBoardGetComments = @"board.getComments";
static NSString *const kVKBoardAddTopic = @"board.addTopic";
static NSString *const kVKBoardAddComment = @"board.addComment";
static NSString *const kVKBoardDeleteTopic = @"board.deleteTopic";
static NSString *const kVKBoardEditTopic = @"board.editTopic";
static NSString *const kVKBoardEditComment = @"board.editComment";
static NSString *const kVKBoardRestoreComment = @"board.restoreComment";
static NSString *const kVKBoardDeleteComment = @"board.deleteComment";
static NSString *const kVKBoardOpenTopic = @"board.openTopic";
static NSString *const kVKBoardCloseTopic = @"board.closeTopic";
static NSString *const kVKBoardFixTopic = @"board.fixTopic";
static NSString *const kVKBoardUnfixTopic = @"board.unfixTopic";

// -----------------------------------------------------------------------------
#pragma mark - Notes
// -----------------------------------------------------------------------------
static NSString *const kVKNotesGet = @"notes.get";
static NSString *const kVKNotesGetById = @"notes.getById";
static NSString *const kVKNotesGetFriendsNotes = @"notes.getFriendsNotes";
static NSString *const kVKNotesAdd = @"notes.add";
static NSString *const kVKNotesEdit = @"notes.edit";
static NSString *const kVKNotesDelete = @"notes.delete";
static NSString *const kVKNotesGetComments = @"notes.getComments";
static NSString *const kVKNotesCreateComment = @"notes.createComment";
static NSString *const kVKNotesEditComment = @"notes.editComment";
static NSString *const kVKNotesDeleteComment = @"notes.deleteComment";
static NSString *const kVKNotesRestoreComment = @"notes.restoreComment";

// -----------------------------------------------------------------------------
#pragma mark - Places
// -----------------------------------------------------------------------------
static NSString *const kVKPlacesAdd = @"places.add";
static NSString *const kVKPlacesGetById = @"places.getById";
static NSString *const kVKPlacesSearch = @"places.search";
static NSString *const kVKPlacesCheckin = @"places.checkin";
static NSString *const kVKPlacesGetCheckins = @"places.getCheckins";
static NSString *const kVKPlacesGetTypes = @"places.getTypes";
static NSString *const kVKPlacesGetCountries = @"places.getCountries";
static NSString *const kVKPlacesGetRegions = @"places.getRegions";
static NSString *const kVKPlacesGetStreetById = @"places.getStreeById";
static NSString *const kVKPlacesGetCountryById = @"places.getCountryById";
static NSString *const kVKPlacesGetCities = @"places.getCities";
static NSString *const kVKPlacesGetCityById = @"places.getCityById";

// -----------------------------------------------------------------------------
#pragma mark - Polls
// -----------------------------------------------------------------------------
static NSString *const kVKPollsGetById = @"polls.getById";
static NSString *const kVKPollsAddVote = @"polls.addVote";
static NSString *const kVKPollsDeleteVote = @"polls.deleteVote";
static NSString *const kVKPollsGetVotes = @"polls.getVotes";

// -----------------------------------------------------------------------------
#pragma mark - Docs
// -----------------------------------------------------------------------------
static NSString *const kVKDocsGet = @"docs.get";
static NSString *const kVKDocsGetById = @"docs.getById";
static NSString *const kVKDocsGetUploadServer = @"docs.getUploadServer";
static NSString *const kVKDocsGetWallUloadServer = @"docs.getWallUploadServer";
static NSString *const kVKDocsSave = @"docs.save";
static NSString *const kVKDocsDelete = @"docs.delete";
static NSString *const kVKDocsAdd = @"docs.add";

// -----------------------------------------------------------------------------
#pragma mark - Fave
// -----------------------------------------------------------------------------
static NSString *const kVKFaveGetUsers = @"fave.getUsers";
static NSString *const kVKFaveGetPhotos = @"fave.getPhotos";
static NSString *const kVKFaveGetPosts = @"fave.getPosts";
static NSString *const kVKFaveGetVideos = @"fave.getVideos";
static NSString *const kVKFaveGetLinks = @"fave.getLinks";

// -----------------------------------------------------------------------------
#pragma mark - Notifications
// -----------------------------------------------------------------------------
static NSString *const kVKNotificationsGet = @"notifications.get";
static NSString *const kVKNotificationsMarkAsViewed = @"notifications.markAsViewed";

// -----------------------------------------------------------------------------
#pragma mark - Stats
// -----------------------------------------------------------------------------
static NSString *const kVKStatsGet = @"stats.get";

// -----------------------------------------------------------------------------
#pragma mark - Search
// -----------------------------------------------------------------------------
static NSString *const kVKSearchGetHints = @"search.getHints";

// -----------------------------------------------------------------------------
#pragma mark  - Apps
// -----------------------------------------------------------------------------
static NSString *const kVKAppsGetCatalog = @"apps.getCatalog";

// -----------------------------------------------------------------------------
#pragma mark  - Ads
// -----------------------------------------------------------------------------
static NSString *const kVKAdsGetAccounts = @"ads.getAccounts";
static NSString *const kVKAdsGetClients = @"ads.getClients";
static NSString *const kVKAdsCreateClients = @"ads.createClients";
static NSString *const kVKAdsUpdateClients = @"ads.updateClients";
static NSString *const kVKAdsDeleteClients = @"ads.deleteClients";
static NSString *const kVKAdsGetCampaigns = @"ads.getCampaigns";
static NSString *const kVKAdsCreateCampaigns = @"ads.createCampaigns";
static NSString *const kVKAdsUpdateCampaigns = @"ads.updateCampaigns";
static NSString *const kVKAdsDeleteCampaigns = @"ads.deleteCampaigns";
static NSString *const kVKAdsGetAds = @"ads.getAds";
static NSString *const kVKAdsGetAdsLayout = @"ads.getAdsLayout";
static NSString *const kVKAdsGetAdsTargeting = @"ads.getAdsTargeting";
static NSString *const kVKAdsCreateAds = @"ads.createAds";
static NSString *const kVKAdsUpdateAds = @"ads.updateAds";
static NSString *const kVKAdsDeleteAds = @"ads.deleteAds";
static NSString *const kVKAdsGetStatistics = @"ads.getStatistics";
static NSString *const kVKAdsGetDemographics = @"ads.getDemographics";
static NSString *const kVKAdsGetBudget = @"ads.getBudget";
static NSString *const kVKAdsGetOfficeUsers = @"ads.getOfficeUsers";
static NSString *const kVKAdsAddOfficeUsers = @"ads.addOfficeUsers";
static NSString *const kVKAdsRemoveOfficeUsers = @"ads.removeOfficeUsers";
static NSString *const kVKAdsGetTargetingStats = @"ads.getTargetingStats";
static NSString *const kVKAdsGetSuggestions = @"ads.getSuggestions";
static NSString *const kVKAdsGetCategories = @"ads.getCategories";
static NSString *const kVKAdsGetUploadURL = @"ads.getUploadURL";
static NSString *const kVKAdsGetVideoUploadURL = @"ads.getVideoUploadURL";
static NSString *const kVKAdsGetFloodStats = @"ads.getFloodStats";
static NSString *const kVKAdsGetRejectionReason = @"ads.getRejectionReason";
static NSString *const kVKAdsCreateTargetGroup = @"ads.createTargetGroup";
static NSString *const kVKAdsUpdateTargetGroup = @"ads.updateTargetGroup";
static NSString *const kVKAdsDeleteTargetGroup = @"ads.deleteTargetGroup";
static NSString *const kVKAdsGetTargetGroups = @"ads.getTargetGroups";
static NSString *const kVKAdsImportTargetContacts = @"ads.importTargetContacts";

// -----------------------------------------------------------------------------
#pragma mark  - Execute
// -----------------------------------------------------------------------------
static NSString *const kVKExecute = @"execute";

// -----------------------------------------------------------------------------
#pragma mark  - Utils
// -----------------------------------------------------------------------------
static NSString *const kVKUtilsCheckLink = @"utils.checkLink";
static NSString *const kVKUtilsResolveScreenName = @"utils.resolveScreenName";
static NSString *const kVKUtilsGetServerTime = @"utils.getServerTime";

// -----------------------------------------------------------------------------
#pragma mark  - Database
// -----------------------------------------------------------------------------
static NSString *const kVKDatabaseGetCountries = @"database.getCountries";
static NSString *const kVKDatabaseGetRegions = @"database.getRegions";
static NSString *const kVKDatabaseGetStreetsById = @"database.getStreetsById";
static NSString *const kVKDatabaseGetCountriesById = @"database.getCountriesById";
static NSString *const kVKDatabaseGetCities = @"database.getCities";
static NSString *const kVKDatabaseGetCitiesById = @"database.getCitiesById";
static NSString *const kVKDatabaseGetUniversities = @"database.getUniversities";
static NSString *const kVKDatabaseGetSchools = @"database.getSchools";
static NSString *const kVKDatabaseGetFaculties = @"database.getFaculties";