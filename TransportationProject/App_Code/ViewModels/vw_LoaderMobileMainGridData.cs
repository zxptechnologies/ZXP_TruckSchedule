using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TransportationProject
{
    public class vw_LoaderMobileMainGridData
    {
        public int MSID { get; set; }
        public int StatusID { get; set; }
        public string StatusName { get; set; }
        public string PONumber { get; set; }
        public string PONumber_ZXPOutbound { get; set; }
        public int SpotID { get; set; }
        public string SpotName { get; set; }
        public string LoadTypes { get; set; }
        public string ProductID_CMS { get; set; }
        public string ProductName_CMS { get; set; }
        public string TrailerNumber { get; set; }
        public int PODetailsID { get; set; }
        public DateTime ETA { get; set; }

    }
}