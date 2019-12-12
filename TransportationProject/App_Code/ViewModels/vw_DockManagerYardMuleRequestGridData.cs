using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TransportationProject
{
    public class vw_DockManagerYardMuleRequestGridData
    {
        
        public int MSID { get; set; }
        public int PONumber { get; set; }
        public int RequestID { get; set; }
        public string Task { get; set; }
        public int? Assignee { get; set; }
        public int Requester { get; set; }
        public string Comment { get; set; }
        public int? NewSpotID { get; set; }
        public int? AssignedDockSpot { get; set; }
        public DateTime TimeRequestSent { get; set; }
        public DateTime? TimeRequestStart { get; set; }
        public DateTime? TimeRequestEnd { get; set; }
        public string TrailerNumber { get; set; }
        public int RequestTypeID { get; set; }
        public DateTime RequestDueDateTime { get; set; }
        public string TruckType { get; set; }
        public bool isRejected { get; set; }
        public bool isOpenInCMS { get; set; }
        public int? currentDockSpotID { get; set; }
        public string CurrentSpot { get; set; }
        public int ProdCount { get; set; }
        public string topProdID { get; set; }
        public string ProductName_CMS { get; set; }
        public DateTime SpotReserveTime { get; set; }

        
    }
}