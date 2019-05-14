using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TransportationProjectDataLayer.ViewModels
{
    public class vm_dd_TruckDockSpots
    {
        public vm_dd_TruckDockSpots()
        { }

        public vm_dd_TruckDockSpots(int id)
        {
            Id = id;
        }

        public vm_dd_TruckDockSpots(int id, string desc, string sType)
        {
            Id = id;
            Description = desc;
            Type = sType;
        }

        public int Id { get; private set; }
        public string Description { get; set; }
        public string Type { get; set; }

        public static implicit operator DomainModels.TruckDockSpots(vm_dd_TruckDockSpots vmSpot)
        {
            DomainModels.TruckDockSpots spot = new DomainModels.TruckDockSpots(vmSpot);
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
