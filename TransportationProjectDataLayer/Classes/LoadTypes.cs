using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TransportationProjectDataLayer
{
    public class LoadTypes
    {
        public string ShortName { get; private set; }
        public string LongName { get; private set; }
        public bool isUsedOnlyForInspections { get; private set; }

        public LoadTypes(string shortname, string longname, bool isForInspections)
        {
            this.ShortName = shortname;
            this.LongName = longname;
            this.isUsedOnlyForInspections = isForInspections;

        }
    }
}
