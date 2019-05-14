using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TransportationProjectDataLayer.DomainModels
{
    public class Locations
    {

        public Locations()
        {
        }
        public Locations(string locShort, string locLong)
        {
            LocationShort = locShort;
            LocationLong = locLong;

        }
        
        public string LocationShort { get; private set; }


        public string LocationLong { get; private set; }
    }
}
