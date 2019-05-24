
function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var MainScheduleEvent = function MainScheduleEvent(MSEObj) {
    _classCallCheck(this, MainScheduleEvent);

    this.MSID = MSEObj.MSID;
    this.EventTypeID = MSEObj.EventTypeID;
    this.EventSubtypeID = MSEObj.EventSubtypeID;
    this.TimeStamp = MSEObj.TimeStamp;
    this.UserID = MSEObj.UserID;
    this.isHidden = MSEObj.isHidden;
};


var ZXPUserData = function ZXPUserData(ZUDObj) {
    _classCallCheck(this, ZXPUserData);

    this._uid = ZUDObj._uid;
    this._isValid = ZUDObj._isValid;
    this._isAdmin = ZUDObj._isAdmin;
    this._isDockManager = ZUDObj._isDockManager;
    this._isInspector = ZUDObj._isInspector;
    this._isGuard = ZUDObj._isGuard;
    this._isLabPersonnel = ZUDObj._isLabPersonnel;
    this._isLoader = ZUDObj._isLoader;
    this._isYardMule = ZUDObj._isYardMule;
    this._isLabAdmin = ZUDObj._isLabAdmin;
    this._isAccountManager = ZUDObj._isAccountManager;
    this._canViewReports = ZUDObj._canViewReports;
    this._UserName = ZUDObj._UserName;
    this._FirstName = ZUDObj._FirstName;
    this._LastName = ZUDObj._LastName;
};



var InspectionQuestion = function InspectionQuestion(IQObj) {
    _classCallCheck(this, InspectionQuestion);

    this.MSInspectionID = IQObj.MSInspectionID;
    this.TestID = IQObj.TestID;
    this.Result = IQObj.Result;
    this.SubmittedTimeStamp = IQObj.SubmittedTimeStamp;
    this.UserID = IQObj.UserID;
    this.Comment = IQObj.Comment;
    this.TestDescription = IQObj.TestDescription;
    this.SortOrder = IQObj.SortOrder;
    this.isDealBreaker = IQObj.isDealBreaker;
};

var InspectionListDetails = function InspectionListDetails(ILDObj) {
    _classCallCheck(this, InspectionListDetails);

    this.MSInspectionListDetailsID = ILDObj.MSInspectionListDetailsID;
    this.MSInspectionListID = ILDObj.MSInspectionListID;
    this.InspectionHeaderID = ILDObj.InspectionHeaderID;
    this.InspectionHeaderName = ILDObj.InspectionHeaderName;
    this.SortOrder = ILDObj.SortOrder;
    this.MSInspection = new Inspection(ILDObj.MSInspection);
    this.MSInspection.copyQuestionList(ILDObj.MSInspection.questions);
};

var InspectionList = function InspectionList(IlObj) {
    _classCallCheck(this, InspectionList);

    this.MSInspectionListID = IlObj.MSInspectionListID;
    this.MSID = IlObj.MSID;
    this.InspectionListID = IlObj.InspectionListID;
    this.InspectionListName = IlObj.InspectionListName;
    this.ProductID_CMS = IlObj.ProductID_CMS;
    this.RunNumber = IlObj.RunNumber;
    this.isHidden = IlObj.isHidden;
    this.InspectionListDetails = [];

    this.copyInspectionListDetail = function (inspectionListDetailsObj) {
        for (var i = 0; i < inspectionListDetailsObj.length; i++) {
            var newInspectionListDetail = new InspectionListDetails(inspectionListDetailsObj[i]);
            //newInspection.copyQuestionList(inspectionListDetailsObj[i]["questions"]);
            this.InspectionListDetails[i] = newInspectionListDetail;
        }
    };
};

var Inspection = function Inspection(IObj) {
    _classCallCheck(this, Inspection);

    this.MSInspectionID = IObj.MSInspectionID;
    this.InspectionHeaderID = IObj.InspectionHeaderID;
    this.MSInspectionListDetailID = IObj.MSInspectionListDetailID;
    this.InspectionStartEventID = IObj.InspectionStartEventID;
    this.InspectionEndEventID = IObj.InspectionEndEventID;
    this.isHidden = IObj.isHidden;
    this.InspectionHeaderName = IObj.InspectionHeaderName;
    this.InspectionTypeID = IObj.InspectionTypeID;
    this.LoadType = IObj.LoadType;
    this.UserID = IObj.UserID;
    this.RunNumber = IObj.RunNumber;
    this.InspectionComment = IObj.InspectionComment;
    this.needsVerificationTest = IObj.needsVerificationTest;
    this.isFailed = IObj.isFailed;
    this.wasAutoClosed = IObj.wasAutoClosed;
    this.questions = []; //new List<InspectionQuestion>();
    this.MSStartEvent = new MainScheduleEvent(IObj["MSStartEvent"]); // new MainScheduleEvent();
    this.MSEndEvent = new MainScheduleEvent(IObj["MSEndEvent"]); //new MainScheduleEvent();
    this.UserLastModified = new ZXPUserData(IObj["UserLastModified"]); // new ZXPUserData();
    this.UserVerifying = new ZXPUserData(IObj["UserVerifying"]); // new ZXPUserData();
    this.UserCreated = new ZXPUserData(IObj["UserCreated"]); //new ZXPUserData();
    this.LastModifiedTimestamp = IObj.LastModifiedTimestamp;

    this.copyQuestionList = function (questionList) {
        for (var i = 0; i < questionList.length; i++) {
            var newQuestion = new InspectionQuestion(questionList[i]);
            this.questions[i] = newQuestion;
        }
    };
};