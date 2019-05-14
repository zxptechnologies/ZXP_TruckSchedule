using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TransportationProjectDataLayer.DomainModels
{
    public class TruckTypes
    {

        public TruckTypes()
        {
        }
        public TruckTypes(string shortname, string longname)
        {
            TruckTypeShort = shortname;
            TruckTypeLong = longname;
        }

        public string TruckTypeShort { get; private set; }
        public string TruckTypeLong { get; private set; }

    }
}
