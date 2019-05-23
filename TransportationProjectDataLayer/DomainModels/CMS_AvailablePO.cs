using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TransportationProjectDataLayer
{
    public class CMS_AvailablePO
    {
        public int PONUM { get; set; }
        public string Prod1 { get; set; }
        public string Prod2 { get; set; }
        public string Prod3 { get; set; }
        public bool isOrder { get; set; }
        public string ZXPPONUM { get; set; }

        public CMS_AvailablePO(int po, string prod1, string prod2, string prod3, bool isPOAnOrder, string zxpPO)
        {
            PONUM = po;
            Prod1 = prod1;
            Prod2 = prod2;
            Prod3 = prod3;
            isOrder = isPOAnOrder;
            ZXPPONUM = zxpPO;
        }
        public CMS_AvailablePO()
        {
            PONUM = 0;
            Prod1 = string.Empty ;
            Prod2 = string.Empty;
            Prod3 = string.Empty;
            isOrder = false;
            ZXPPONUM = string.Empty;
        }
    }
}
