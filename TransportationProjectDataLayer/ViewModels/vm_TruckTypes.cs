using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TransportationProjectDataLayer.ViewModels
{
    public class vm_TruckTypes
    {

        public vm_TruckTypes()
        {
        }
        public vm_TruckTypes(string shortname, string longname)
        {
            TruckTypeShortname = shortname;
            TruckTypeLongname = longname;
        }

        public string TruckTypeShortname { get; set; }
        public string TruckTypeLongname { get; set; }

        public static implicit operator DomainModels.TruckTypes(vm_TruckTypes vmTType)
        {
            DomainModels.TruckTypes tType = new DomainModels.TruckTypes(vmTType.TruckTypeShortname, vmTType.TruckTypeLongname);
            return tType;
        }

        public static implicit operator vm_TruckTypes(DomainModels.TruckTypes tType)
        {

            return new vm_TruckTypes
            {
                TruckTypeShortname = tType.TruckTypeShort,
                TruckTypeLongname = tType.TruckTypeLong
            };

        }
    }
}
