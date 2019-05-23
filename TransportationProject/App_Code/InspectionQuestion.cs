using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TransportationProject
{
    public class InspectionQuestion
    {

        public int MSInspectionID { get; private set; }
        public int TestID { get; private set; }
        public int Result { get; private set; }
        public DateTime ? SubmittedTimeStamp { get; private set; }
        public int ? UserID { get; private set; }
        public string Comment { get; private set; }
        public string TestDescription { get; private set; }
        public int SortOrder { get; private set; }
        public bool isDealBreaker { get; private set; }
        
        public InspectionQuestion(int MSInspectionID , int TestID , int Result, DateTime ? SubmittedTimeStamp, int ? UserID, string Comment, string TestDescription, int SortOrder, bool isDealBreaker)
        {
            this.MSInspectionID = MSInspectionID;
            this.TestID = TestID;
            this.Result = Result;
            this.SubmittedTimeStamp = SubmittedTimeStamp;
            this.UserID = UserID;
            this.Comment = Comment;
            this.TestDescription = TestDescription;
            this.SortOrder = SortOrder;
            this.isDealBreaker = isDealBreaker;
        }


        public InspectionQuestion()
        {
            this.MSInspectionID = 0;
            this.TestID = 0;
            this.Result = 0;
            this.SubmittedTimeStamp = new DateTime(1900, 1, 1);
            this.UserID = 0;
            this.Comment = string.Empty;
            this.TestDescription = string.Empty;
            this.SortOrder = 0;
            this.isDealBreaker = true;
        }



    }

}