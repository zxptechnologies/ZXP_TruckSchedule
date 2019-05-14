using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TransportationProjectDataLayer
{
    public class TrailerGridData
    {

        public int MSID { get; set; }
        public DateTime ETA { get; set; }
        public string Comments { get; set; }
        public string LoadTypeShort { get; set; }
        public string LoadTypeLong { get; set; }
        public int PONumber { get; set; }
        public string CustomerID { get; set; }
        public bool isDropTrailer { get; set; }
        public string Shipper { get; set; }
        public int DockSpotID { get; set; }
        public string TruckType { get; set; }
        public bool isRejected { get; set; }
        public string TrailerNumber { get; set; }
        public string LocationShort { get; set; }
        public string LocationLong { get; set; }
        public int StatusID { get; set; }
        public string StatusText { get; set; }
        public string SpotDescription { get; set; }
        public bool isOpenInCMS { get; set; }
        public int ProdCount { get; set; }
        public string topProdID { get; set; }
        public string ProductName_CMS { get; set; }
        public string PONumber_ZXPOutbound { get; set; }
        public bool isUrgent { get; set; }
        public bool isManuallyClosed { get; set; }
        public string ClosedBy { get; set; }


    }
}
