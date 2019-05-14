using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TransportationProjectDataLayer.ViewModels
{
    public class vm_dd_Status
    {
        public vm_dd_Status() { }
        public vm_dd_Status(int id, string text)
        {
            StatusID = id;
            StatusText = text;
        }

        public int StatusID { get;  set; }
        public string StatusText { get;  set; }

        public static implicit operator DomainModels.Status(vm_dd_Status vmStat)
        {
            DomainModels.Status stat = new DomainModels.Status(vmStat.StatusID, vmStat.StatusText, null);
            return stat;
        }

        public static implicit operator vm_dd_Status(DomainModels.Status stat)
        {

            return new vm_dd_Status
            {
                StatusID = stat.StatusID,
                StatusText = stat.StatusText
            };
        }

    }
}
