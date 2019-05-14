using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TransportationProjectDataLayer.ViewModels
{
    public class vm_UnitOfMeasure
    {
        public vm_UnitOfMeasure() { }
        public vm_UnitOfMeasure(string shortname, string longname)
        {
            UnitShortname = shortname;
            UnitLongname = longname;
        }
        public string UnitShortname { get; set; }
        public string UnitLongname { get; set; }

        public static implicit operator DomainModels.UnitOfMeasure(vm_UnitOfMeasure vmUnit)
        {
            DomainModels.UnitOfMeasure unitMeasure = new DomainModels.UnitOfMeasure(vmUnit.UnitShortname, vmUnit.UnitLongname);
            return unitMeasure;
        }

        public static implicit operator vm_UnitOfMeasure(DomainModels.UnitOfMeasure unitMeasure)
        {

            return new vm_UnitOfMeasure
            {
                UnitShortname = unitMeasure.UnitShort,
                UnitLongname = unitMeasure.UnitLong
            };

        }
    }
}
