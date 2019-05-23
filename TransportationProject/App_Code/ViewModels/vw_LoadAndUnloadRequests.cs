using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TransportationProject
{
    public class vw_LoadAndUnloadRequests
    {
        public int RequestID { get; private set; }
        public int MSID { get; private set; }
        public int RequestTypeID { get; private set; }
        public DateTime? TimeRequestStart { get; private set;  }
        public DateTime? TimeRequestEnd { get; private set; }

        public vw_LoadAndUnloadRequests(int RID, int msid, int TypeID, DateTime? StartTime, DateTime? EndTime)
        {
            this.RequestID = RID;
            this.MSID = msid;
            this.RequestTypeID = TypeID;
            this.TimeRequestStart = StartTime;
            this.TimeRequestEnd = EndTime;
        }
    }
}