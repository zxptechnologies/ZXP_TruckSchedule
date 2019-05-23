using System;
using System.Data;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks.Data;

namespace TransportationProject
{

    //Keep updated with database table dbo.MainscheduleEvents
    public class MainScheduleEvent
    {

        public int EventID { get; private set; }
        public int MSID { get; private set; }
        public int EventTypeID { get; private set; }
        public int? EventSubtypeID { get; private set; }
        public DateTime TimeStamp { get; private set; }
        public int UserID { get; private set; }
        public bool isHidden { get; private set; }


        public MainScheduleEvent()
        {
            this.MSID = 0;
            this.EventTypeID = 0;
            this.EventSubtypeID = 0;
            this.TimeStamp = new DateTime(1900, 1,1);
            this.UserID = 0;
            this.isHidden = true;
        }
        public MainScheduleEvent(int nMSID, int nEventTypeID, int? nEventSubtypeID, DateTime nTimeStamp, int nUserID, bool nIsHidden)
        {
            this.MSID = nMSID;
            this.EventTypeID = nEventTypeID;
            this.EventSubtypeID = nEventSubtypeID;
            this.TimeStamp = nTimeStamp;
            this.UserID = nUserID;
            this.isHidden = nIsHidden;
        }
        public MainScheduleEvent(MainScheduleEvent newMSEvent)
        {
            this.EventID = newMSEvent.EventID;
            this.MSID = newMSEvent.MSID;
            this.EventTypeID = newMSEvent.EventTypeID;
            this.EventSubtypeID = newMSEvent.EventSubtypeID;
            this.TimeStamp = newMSEvent.TimeStamp;
            this.UserID = newMSEvent.UserID;
            this.isHidden = newMSEvent.isHidden;
            this.EventID = newMSEvent.EventID;
        }

        public void setEventID(int nEventID)
        {
            this.EventID = nEventID;
        }

        public static MainScheduleEvent getEventData(int ? EventID)
        {
            string sqlQuery = "SELECT MSID, EventTypeID, EventSubTypeID, TimeStamp, UserId, isHidden FROM dbo.MainScheduleEvents " +
                              "WHERE EventID = @EID AND isHidden = 0";

            string sql_connStr = new TruckScheduleConfigurationKeysHelper().sql_connStr;

            DataSet MSEventData = SqlHelper.ExecuteDataset(sql_connStr, CommandType.Text, sqlQuery, new SqlParameter("@EID", EventID));
            int MSID = Convert.ToInt32(MSEventData.Tables[0].Rows[0]["EventTypeID"]);
            int EventTypeID = Convert.ToInt32(MSEventData.Tables[0].Rows[0]["EventTypeID"]);
            int ? EventSubTypeID = (MSEventData.Tables[0].Rows[0]["EventSubTypeID"] == DBNull.Value) ? (int?) null : Convert.ToInt32(MSEventData.Tables[0].Rows[0]["EventSubTypeID"]);
            DateTime TimeStamp = Convert.ToDateTime(MSEventData.Tables[0].Rows[0]["TimeStamp"]);
            int UserId = Convert.ToInt32(MSEventData.Tables[0].Rows[0]["UserId"]);
            bool isHidden = Convert.ToBoolean(MSEventData.Tables[0].Rows[0]["isHidden"]);


            MainScheduleEvent newMSEvent = new MainScheduleEvent(MSID, EventTypeID, EventSubTypeID, TimeStamp, UserId, isHidden);

            return newMSEvent;
        }

    }
}