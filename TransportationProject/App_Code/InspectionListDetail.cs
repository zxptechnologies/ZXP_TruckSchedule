using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TransportationProject
{
    public class InspectionListDetails
    {

        public int MSInspectionListDetailsID { get; private set; }
        public int MSInspectionListID { get; private set; }
        //public int InspectionListID { get; private set; }
        public int InspectionHeaderID { get; private set; }
        public string InspectionHeaderName { get; private set; }
        public int SortOrder { get; private set; }
        public Inspection MSInspection { get; private set; }

        public InspectionListDetails(int MSInspectionListDetailsID, int MSInspectionListID, int InspectionHeaderID, string InspectionHeaderName, int SortOrder, Inspection MSInspection )
        {
            this.MSInspectionListDetailsID = MSInspectionListDetailsID;
            this.MSInspectionListID = MSInspectionListID;
            this.InspectionHeaderID = InspectionHeaderID;
            this.InspectionHeaderName = InspectionHeaderName;
            this.SortOrder = SortOrder;
            this.MSInspection = MSInspection;

        }

        
    }
}