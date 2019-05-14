using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TransportationProjectDataLayer
{
    public class PODetails
    {
        public string ProductName_CMS { get; set; }
        public int PODetailsID { get; set; }
        public string ProductID_CMS { get; set; }
        public int MSID { get; set; }
        public int QTY { get; set; }
        public string LotNumber { get; set; }
        public string UnitOfMeasure { get; set; }
        public int FileID_COFA { get; set; }
    }
}
