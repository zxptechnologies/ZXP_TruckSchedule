using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Transactions;
using System.Web;

namespace TransportationProject
{
    public class InspectionList
    {
        public int MSInspectionListID { get; private set; }
        public int MSID { get; private set; }
        public int InspectionListID { get; private set; }
        public string InspectionListName { get; private set; }
        public string ProductID_CMS { get; private set; }
        public int RunNumber { get; private set; }
        public bool isHidden { get; private set; }
        public List<InspectionListDetails> InspectionListDetails { get; private set; }

        public InspectionList(int MSInspectionListID, int MSID, int InspectionListID, string InspectionListName, string ProductID_CMS,int RunNumber, bool isHidden)
        {
            this.MSInspectionListID = MSInspectionListID;
            this.MSID = MSID;
            this.InspectionListID = InspectionListID;
            this.InspectionListName = InspectionListName;
            this.ProductID_CMS = ProductID_CMS;
            this.RunNumber = RunNumber;
            this.isHidden = isHidden;
            InspectionListDetails = new List<InspectionListDetails>();
        }

        public InspectionList()
        {
            this.MSInspectionListID = 0 ;
            this.MSID = 0;
            this.InspectionListID = 0;
            this.InspectionListName = string.Empty;
            this.ProductID_CMS = string.Empty;
            this.RunNumber = 0;
            this.isHidden = true;
            InspectionListDetails = new List<InspectionListDetails>();
        }


        public void addInspectionListDetail(InspectionListDetails newInspectionListDetail)
        {
            this.InspectionListDetails.Add(newInspectionListDetail);
        }

    }
}