using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TransportationProjectDataLayer.DomainModels
{
    public class UnitOfMeasure
    {
        public UnitOfMeasure() { }
        public UnitOfMeasure(string shortname, string longname)
        {
            UnitShort = shortname;
            UnitLong = longname;
        }
        public string UnitShort { get; private set; }
        public string UnitLong { get; private set; }

    }
}
