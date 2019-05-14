using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TransportationProjectDataLayer.ViewModels
{
    public class vm_Locations
    {

        public vm_Locations()
        {
        }
        public vm_Locations(string locShort, string locLong)
        {
            LocationShortname = locShort;
            LocationLongname = locLong;

        }
        
        public string LocationShortname { get; set; }
        public string LocationLongname { get; set; }

        public static implicit operator DomainModels.Locations(vm_Locations vmLoc)
        {
            DomainModels.Locations Loc = new DomainModels.Locations(vmLoc.LocationShortname, vmLoc.LocationLongname);
            return Loc;
        }

        public static implicit operator vm_Locations(DomainModels.Locations Loc)
        {

            return new vm_Locations
            {
                LocationShortname = Loc.LocationShort,
                LocationLongname = Loc.LocationLong
            };

        }
    }
}
