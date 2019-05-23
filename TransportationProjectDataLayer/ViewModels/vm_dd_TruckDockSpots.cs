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
            DomainModels.TruckDockSpots spot = new DomainModels.TruckDockSpots(vmSpot.Id);
            return spot;
        }

        public static implicit operator vm_dd_TruckDockSpots(DomainModels.TruckDockSpots truckdockspot)
        {

            return new vm_dd_TruckDockSpots
            {
                Id = truckdockspot.SpotId,
                Description = truckdockspot.SpotDescription,
                Type = truckdockspot.SpotType,
            };

        }

    }
}
