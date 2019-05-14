using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TransportationProjectDataLayer.ViewModels
{
    public class vm_AvailablePoNum
    {

        public vm_AvailablePoNum() {
        }
        public vm_AvailablePoNum(string po, string p1, string p2, string p3, int isAnOrder, string zxppo)
        {
            PONUM = po;
            Prod1 = p1;
            Prod2 = p2;
            Prod3 = p3;
            isOrder = isAnOrder;
            ZXPPONUM = zxppo;
        }

        public string PONUM { get; set; }
        public string Prod1 { get; set; }
        public string Prod2 { get; set; }
        public string Prod3 { get; set; }
        public int isOrder { get; set; }
        public string ZXPPONUM { get; set; }
      


    }
}
