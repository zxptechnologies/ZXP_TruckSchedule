using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TransportationProject
{
    public class Inspection
    {
        
      public int MSInspectionID { get; private set; }
      public int InspectionHeaderID { get; private set; }
      //public int MSID { get; private set; }
      public int MSInspectionListDetailID { get; private set; }
      public int ? InspectionStartEventID { get; private set; }
      public int? InspectionEndEventID { get; private set; }
      public bool isHidden { get; private set; }
      public string InspectionHeaderName { get; private set; }
      public int ? InspectionTypeID { get; private set; }
      public string LoadType { get; private set; }
      public int ? UserID { get; private set; }
      public int ? RunNumber { get; private set; }
      public string InspectionComment { get; private set; }
      public bool needsVerificationTest { get; private set; }
      public bool isFailed { get; private set; }
      public bool wasAutoClosed { get; private set; }
      public List<InspectionQuestion> questions { get; private set; }
      public MainScheduleEvent MSStartEvent { get; private set; }
      public MainScheduleEvent MSEndEvent { get; private set; }
      public ZXPUserData UserCreated { get; private set; }
      public ZXPUserData UserLastModified { get; private set; }
      public DateTime LastModifiedTimestamp { get; private set; }
      public ZXPUserData UserVerifying { get; private set; }


      public Inspection(int MSInspectionID, int InspectionHeaderID, int MSInspectionListDetailID,  int ? InspectionStartEventID, int ? InspectionEndEventID, 
                        bool isHidden, string InspectionHeaderName, int ? InspectionTypeID , string LoadType, int ? UserID, int ? RunNumber, string InspectionComment, 
                        bool needsVerificationTest,bool isFailed, bool wasAutoClosed, MainScheduleEvent MSStartEvent, MainScheduleEvent MSEndEvent,
                        ZXPUserData UserCreated, ZXPUserData UserVerifying, ZXPUserData UserLastModified, DateTime LastModifiedTimestamp)
      {
          this.MSInspectionID = MSInspectionID;
          this.InspectionHeaderID = InspectionHeaderID;
          this.MSInspectionListDetailID = MSInspectionListDetailID;
          this.InspectionStartEventID = InspectionStartEventID;
          this.InspectionEndEventID = InspectionEndEventID;
          this.isHidden = isHidden;
          this.InspectionHeaderName = InspectionHeaderName;
          this.InspectionTypeID = InspectionTypeID;
          this.LoadType = LoadType;
          this.UserID = UserID;
          this.RunNumber = RunNumber;
          this.InspectionComment = InspectionComment;
          this.needsVerificationTest = needsVerificationTest;
          this.isFailed = isFailed;
          this.wasAutoClosed = wasAutoClosed;
          this.questions = new List<InspectionQuestion>();
          this.MSStartEvent = MSStartEvent;
          this.MSEndEvent = MSEndEvent;
          this.UserCreated = UserCreated;
          this.UserVerifying = UserVerifying;
          this.UserLastModified = UserLastModified;
          this.LastModifiedTimestamp = LastModifiedTimestamp;

      }

      public Inspection(int MSInspectionID, int InspectionHeaderID, int MSInspectionListDetailID, int ? InspectionStartEventID, int ? InspectionEndEventID,
                      bool isHidden, string InspectionHeaderName, int ? InspectionTypeID, string LoadType, int? UserID, int? RunNumber, string InspectionComment,
                      bool needsVerificationTest, bool isFailed, bool wasAutoClosed, List<InspectionQuestion> questions, MainScheduleEvent MSStartEvent, MainScheduleEvent MSEndEvent,
                      ZXPUserData UserCreated, ZXPUserData UserVerifying, ZXPUserData UserLastModified, DateTime LastModifiedTimestamp)
      {
          this.MSInspectionID = MSInspectionID;
          this.InspectionHeaderID = InspectionHeaderID;
          this.MSInspectionListDetailID = MSInspectionListDetailID;
          this.InspectionStartEventID = InspectionStartEventID;
          this.InspectionEndEventID = InspectionEndEventID;
          this.isHidden = isHidden;
          this.InspectionHeaderName = InspectionHeaderName;
          this.InspectionTypeID = InspectionTypeID;
          this.LoadType = LoadType;
          this.UserID = UserID;
          this.RunNumber = RunNumber;
          this.InspectionComment = InspectionComment;
          this.needsVerificationTest = needsVerificationTest;
          this.isFailed = isFailed;
          this.wasAutoClosed = wasAutoClosed;
          this.questions = questions;
          this.MSStartEvent = MSStartEvent;
          this.MSEndEvent = MSEndEvent;
          this.UserCreated = UserCreated;
          this.UserVerifying = UserVerifying;
          this.UserLastModified = UserLastModified;
          this.LastModifiedTimestamp = LastModifiedTimestamp;
      }



      public Inspection()
      {
          this.MSInspectionID = 0;
          this.InspectionHeaderID = 0;
          this.MSInspectionListDetailID = 0;
          this.InspectionStartEventID = 0;
          this.InspectionEndEventID = 0;
          this.isHidden = true;
          this.InspectionHeaderName = string.Empty;
          this.InspectionTypeID = 0;
          this.LoadType = string.Empty;
          this.UserID = 0;
          this.RunNumber = 0;
          this.InspectionComment = string.Empty;
          this.needsVerificationTest = true;
          this.isFailed = true;
          this.wasAutoClosed = true;
          this.questions = new List<InspectionQuestion>();
          this.MSStartEvent = new MainScheduleEvent();
          this.MSEndEvent = new MainScheduleEvent();
          this.UserLastModified = new ZXPUserData();
          this.UserVerifying = new ZXPUserData();
          this.UserCreated = new ZXPUserData();
          this.LastModifiedTimestamp = new DateTime(1900, 1, 1);
          
      }




      public void addQuestion(InspectionQuestion newQuestion)
      {
          this.questions.Add(newQuestion);
      }

       
    }



}